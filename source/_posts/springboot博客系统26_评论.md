# 实验介绍

#### 实验内容

在文章详情页面制作的那节实验课程中，我们提到了文章详情页的页面中还会有**文章的评论列表区域**和**文章评论的输入区域**，但是在那个实验中并没有直接讲解和介绍，主要是考虑到篇幅的缘故，评论模块不仅仅是详情页的评论添加和列表，还有后台管理系统中的评论管理功能模块，因此就选择单独用一个章节来讲解博客系统的评论模块，包括详情页的功能开发和后台管理系统中的评论管理页面和相关接口的开发。

#### 实验知识点

- 评论模块介绍
- 评论模块表结构设计及接口实现
- 评论模块页面设计及编码
- 评论功能测试

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-30.zip
unzip My-Blog-30.zip
cd My-Blog
```

# 评论模块简介

相信大家对于评论模块并不陌生，不管是电商网站还是视频及音乐网站，评论模块都是不可或缺的，我们通过评论可以看到大家对于一个当前这个事物的评价和建议，通过这些评论可以大致的了解该事物的一些属性，甚至你会觉得评论数据也和详情模块一样，帮助我们更加清晰的了解到眼前的这个事物，但是二者的区别还是很大的，详情模块是运营人员设置的，而评论数据则是用户留下的数据，二者的来源就有很大的不同。回到我们的博客系统中来，论坛、博客、公众号等也都会有的模块，用户在文章下通过文字或者图片来留下自己的评论信息，通过这些文案来表达自己的问题和建议，甚至对文章中提到的内容进行拓展和完善，因此评论模块的开发也是必须的。

在简单的介绍了评论模块后，我们来看一下本系统中的评论页面是怎样的，评论的相关功能模块主要出现在两个地方：

- 其一是博客详情页中会展示评论信息，主要包括评论的列表展示和评论提交；

  **评论列表：** ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381579075/wm)

  **评论提交：** ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381593526/wm)

- 其二是后台管理系统中会有评论数据的管理页面，主要包括评论列表、评论审核和评论回复的功能。

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381606783/wm)

# 表结构设计及 Mapper 文件自动生成

在进行接口设计和具体的功能实现前，首先将表结构确定下来，主要通过观察前文中几张评论模块的图片来确认一些字段的设置，首先是详情页中的评论展示功能，可以看出评论信息是在某一篇博客下评论，因此需要关联博客主键 id， 同时该系统并没有设置用户体系，而是谁都可以评论，用户评论时需要填写一些信息和验证，评论提交就是普通字符串信息提交，包括一些基础的字段填写，之后是评论信息管理页面，有审核功能，所以评论数据应该有状态字段，有回复功能但是并没有开发多级回复，所以还有一个回复内容字段。

总结下来，评论表中重要的字段如下：

- **关联的文章主键 blogId**
- **评论者名称**
- **评论人的邮箱**
- **评论内容**
- **回复内容**
- **审核状态**

基于以上分析设计的评论表的 SQL 语句如下，直接执行如下 SQL 语句即可：

```
USE `my_blog_db`;
DROP TABLE IF EXISTS `tb_blog_comment`;
CREATE TABLE `tb_blog_comment` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `blog_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '关联的blog主键',
  `commentator` varchar(50) NOT NULL DEFAULT '' COMMENT '评论者名称',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '评论人的邮箱',
  `website_url` varchar(50) NOT NULL DEFAULT '' COMMENT '网址',
  `comment_body` varchar(200) NOT NULL DEFAULT '' COMMENT '评论内容',
  `comment_create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论提交时间',
  `commentator_ip` varchar(20) NOT NULL DEFAULT '' COMMENT '评论时的ip地址',
  `reply_body` varchar(200) NOT NULL DEFAULT '' COMMENT '回复内容',
  `reply_create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '回复时间',
  `comment_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否审核通过 0-未审核 1-审核通过',
  `is_deleted` tinyint(4) DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

加了一些时间字段和一些固定的字段，把表结构导入到数据库中即可，接下来使用 MyBatis-Generator 插件将该表对应的 Mapper 文件及对应的实体类和 Dao 层接口生成出来并针对 is_deleted 字段对部分 SQL 进行修改即可，可参考前文中的知识点进行修改。

# 评论管理页面制作

#### 导航栏

首先在左侧导航栏中新增评论管理页的导航按钮，在 sidebar.html 文件中新增如下代码：(**注：完整代码位于 resources/templates/admin/sidebar.html**)

```
                <li class="nav-item">
                    <a th:href="@{/admin/comments}" th:class="${path}=='comments'?'nav-link active':'nav-link'">
                        <i class="fa fa-comments nav-icon" aria-hidden="true"></i>
                        <p>
                            评论管理
                        </p>
                    </a>
                </li>
```

点击后的跳转路径为 /admin/comments，之后我们新建 Controller 来处理该路径并跳转到对应的页面。

#### Controller 处理跳转

首先在 controller/admin 包下新建 CommentController.java，之后新增如下代码：

```
package com.site.blog.my.core.controller.admin;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletRequest;
@Controller
@RequestMapping("/admin")
public class CommentController {
    @GetMapping("/comments")
    public String list(HttpServletRequest request) {
        request.setAttribute("path", "comments");
        return "admin/comment";
    }
}
```

该方法用于处理 /admin/comments 请求，并设置 path 字段，之后跳转到 admin 目录下的 comment.html 中。

#### comment.html 页面制作

接下来就是博客编辑页面的模板文件制作了，在 resources/templates/admin 目录下新建 comment.html，并引入对应的 js 文件和 css 样式文件，代码如下：

```
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<header th:replace="admin/header::header-fragment"></header>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
    <!-- 引入页面头header-fragment -->
    <div th:replace="admin/header::header-nav"></div>
    <!-- 引入工具栏sidebar-fragment -->
    <div th:replace="admin/sidebar::sidebar-fragment(${path})"></div>
    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <div class="content-header">
            <div class="container-fluid">
            </div><!-- /.container-fluid -->
        </div>
        <!-- Main content -->
        <div class="content">
            <div class="container-fluid">
                <div class="card card-primary card-outline">
                    <div class="card-header">
                        <h3 class="card-title">评论管理</h3>
                    </div> <!-- /.card-body -->
                </div>
            </div>
        </div>
    </div>
    <div th:replace="admin/footer::footer-fragment"></div>
</div>
<!-- jQuery -->
<script th:src="@{/admin/plugins/jquery/jquery.min.js}"></script>
<!-- jQuery UI 1.11.4 -->
<script th:src="@{/admin/plugins/jQueryUI/jquery-ui.min.js}"></script>
<!-- Bootstrap 4 -->
<script th:src="@{/admin/plugins/bootstrap/js/bootstrap.bundle.min.js}"></script>
<!-- AdminLTE App -->
<script th:src="@{/admin/dist/js/adminlte.min.js}"></script>
</body>
</html>
```

至此，跳转逻辑处理完毕，演示效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381630352/wm)

# 评论模块接口设计及实现

#### 接口介绍

关于接口的设计以及前后端交互数据的设计大家可以参考一下第 12 课中的内容，友链模块在后台管理系统中有 4 个接口，分别是：

- 评论列表分页接口
- 评论审核接口
- 评论回复接口
- 删除评论接口

接下来讲解每个接口具体的实现代码，首先在 controller/admin 包下新建 CommentController.java，并在 service 包下新建业务层代码 CommentService.java 及实现类，之后参照接口分别进行功能实现。

#### 评论列表分页接口

列表接口负责接收前端传来的分页参数，如 page 、limit 等参数，之后将数据总数和对应页面的数据列表查询出来并封装为分页数据返回给前端。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.CommentController.java**）：

接口的映射地址为 /comments/list，请求方法为 GET，代码如下：

```
    /**
     * 评论列表
     */
    @GetMapping("/comments/list")
    @ResponseBody
    public Result list(@RequestParam Map<String, Object> params) {
        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(commentService.getCommentsPage(pageUtil));
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.CommentServiceImpl.java**）：

```
    public PageResult getCommentsPage(PageQueryUtil pageUtil) {
        List<BlogComment> comments = blogCommentMapper.findBlogCommentList(pageUtil);
        int total = blogCommentMapper.getTotalBlogComments(pageUtil);
        PageResult pageResult = new PageResult(comments, total, pageUtil.getLimit(), pageUtil.getPage());
        return pageResult;
    }
```

- BlogCommentMapper.xml （注：完整代码位于 **resources/mapper/BlogCommentMapper.xml**）：

```
    <select id="findBlogCommentList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog_comment
        where is_deleted=0
        order by comment_id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalBlogComments" parameterType="Map" resultType="int">
        select count(*) from tb_blog_comment
        where is_deleted=0
    </select>
```

SQL 语句在 BlogCommentMapper.xml 文件中，一般的分页也就是使用 limit 关键字实现，获取响应条数的记录和总数之后再进行数据封装，这个接口就是根据前端传的分页参数进行查询并返回分页数据以供前端页面进行数据渲染，评论管理页面的列表是获取全部数据，并不会根据 blog_id 进行过滤。

#### 评论审核接口

审核接口负责接收前端的审核请求，处理前端传输过来的数据后，将这些评论的状态值改为已审核，我们将接受的参数设置为一个数组，可以同时审核多条记录，只需要在前端将用户选择的记录 id 封装好再传参到后端即可。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.CommentController.java**）：

接口的映射地址为 /comments/checkDone ，请求方法为 POST，代码如下：

```
    @PostMapping("/comments/checkDone")
    @ResponseBody
    public Result checkDone(@RequestBody Integer[] ids) {
        if (ids.length < 1) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        if (commentService.checkDone(ids)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("审核失败");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.CommentServiceImpl.java**）：

```
    public Boolean checkDone(Integer[] ids) {
        return blogCommentMapper.checkDone(ids) > 0;
    }   
```

- BlogCommentMapper.xml （注：完整代码位于 **resources/mapper/BlogCommentMapper.xml**）：

```
    <update id="checkDone">
        update tb_blog_comment
        set comment_status=1 where comment_id in
        <foreach item="id" collection="array" open="(" separator="," close=")">
            #{id}
        </foreach>
        and comment_status = 0
    </update>
```

接口的请求路径为 /comments/checkDone，并使用 @RequestBody 将前端传过来的参数封装为 id 数组，参数验证通过后则调用 checkDone() 批量审核方法修改这些记录的审核状态字段。

#### 评论回复接口

评论回复接口可以在评论审核通过之后调用，目的就是给需要回复的评论添加回复字段内容，代码如下

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.CommentController.java**）：

接口的映射地址为 /comments/checkDone ，请求方法为 POST，代码如下：

```
    @PostMapping("/comments/reply")
    @ResponseBody
    public Result checkDone(@RequestParam("commentId") Long commentId,
                            @RequestParam("replyBody") String replyBody) {
        if (commentId == null || commentId < 1 || StringUtils.isEmpty(replyBody)) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        if (commentService.reply(commentId, replyBody)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("回复失败");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.CommentServiceImpl.java**）：

```
    public Boolean reply(Long commentId, String replyBody) {
        BlogComment blogComment = blogCommentMapper.selectByPrimaryKey(commentId);
        //blogComment不为空且状态为已审核，则继续后续操作
        if (blogComment != null && blogComment.getCommentStatus().intValue() == 1) {
            blogComment.setReplyBody(replyBody);
            blogComment.setReplyCreateTime(new Date());
            return blogCommentMapper.updateByPrimaryKeySelective(blogComment) > 0;
        }
        return false;
    }
```

接口的请求路径为 /comments/reply，入参设置为选中的评论记录 id 以及需要回复的内容字段，参数验证通过后则调用 reply() 对表中的回复相关字段做修改，这里是做成了单条记录的回复，如果有需要的话可以适当的修改代码进行功能扩展。

#### 删除评论接口

删除接口负责接收前端的评论删除请求，处理前端传输过来的数据后，将这些记录从数据库中删除，这里的“删除”功能并不是真正意义上的删除，而是逻辑删除，我们将接受的参数设置为一个数组，可以同时删除多条记录，只需要在前端将用户选择的记录 id 封装好再传参到后端即可。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.CommentController.java**）：

接口的映射地址为 /comments/delete，请求方法为 POST，代码如下：

```
    @PostMapping("/comments/delete")
    @ResponseBody
    public Result delete(@RequestBody Integer[] ids) {
        if (ids.length < 1) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        if (commentService.deleteBatch(ids)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("刪除失败");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.CommentServiceImpl.java**）：

```
    public Boolean deleteBatch(Integer[] ids) {
        return blogCommentMapper.deleteBatch(ids) > 0;
    }
```

- BlogCommentMapper.xml （注：完整代码位于 **resources/mapper/BlogCommentMapper.xml**）：

```
    <update id="deleteBatch">
        update tb_blog_comment
        set is_deleted=1 where comment_id in
        <foreach item="id" collection="array" open="(" separator="," close=")">
            #{id}
        </foreach>
    </update>
```

使用 @RequestBody 将前端传过来的参数封装为 id 数组，参数验证通过后则调用 deleteBatch() 批量删除方法进行数据库操作，否则将向前端返回错误信息。

# 前端页面实现

#### 功能按钮

评论管理模块我们也设计了常用的几个功能：评论审核、评论回复、评论删除，因此在页面中添加对应的功能按钮以及触发事件，代码如下：(**注：完整代码位于 resources/templates/admin/comment.html**)

```
                        <div class="grid-btn">
                            <button class="btn btn-success" onclick="checkDoneComments()"><i
                                    class="fa fa-check"></i>&nbsp;批量审核
                            </button>
                            <button class="btn btn-info" onclick="reply()"><i
                                    class="fa fa-reply"></i>&nbsp;回复
                            </button>
                            <button class="btn btn-danger" onclick="deleteComments()"><i
                                    class="fa fa-trash-o"></i>&nbsp;批量删除
                            </button>
                        </div>
```

分别是批量审核按钮对应的触发事件是 checkDoneComments() 方法，回复按钮对应的触发事件是 reply() 方法，删除按钮对应的触发事件是 deleteComments() 方法，这些方法我们将在后续的代码实现中给出。

# 分页信息展示区域

页面中已经引入 JqGrid 的相关静态资源文件，需要在页面中展示分页数据的区域增加如下代码：

```
<table id="jqGrid" class="table table-bordered"></table>
<div id="jqGridPager"></div>
```

#### 页面效果

那么最终的静态页面效果展示如下图所示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381678691/wm)

包括功能按钮、数据列表展示区域，此时只是静态效果展示，并没有与后端进行数据交互，接下来我们将结合 Ajax 和后端接口实现具体的功能。

# 评论管理模块前端功能实现

完成了页面展示的实现，接着完成相关的功能实现。请大家一定自行对照源码完成代码编写。

#### 分页功能

在 resources/static/admin/dist/js 目录下新增 comment.js 文件，并添加如下代码：

```
$(function () {
    $("#jqGrid").jqGrid({
        url: '/admin/comments/list',
        datatype: "json",
        colModel: [
            {label: 'id', name: 'commentId', index: 'commentId', width: 50, key: true, hidden: true},
            {label: '评论内容', name: 'commentBody', index: 'commentBody', width: 120},
            {label: '评论时间', name: 'commentCreateTime', index: 'commentCreateTime', width: 60},
            {label: '评论人名称', name: 'commentator', index: 'commentator', width: 60},
            {label: '评论人邮箱', name: 'email', index: 'email', width: 90},
            {label: '状态', name: 'commentStatus', index: 'commentStatus', width: 60, formatter: statusFormatter},
            {label: '回复内容', name: 'replyBody', index: 'replyBody', width: 120},
        ],
        height: 700,
        rowNum: 10,
        rowList: [10, 20, 50],
        styleUI: 'Bootstrap',
        loadtext: '信息读取中...',
        rownumbers: false,
        rownumWidth: 20,
        autowidth: true,
        multiselect: true,
        pager: "#jqGridPager",
        jsonReader: {
            root: "data.list",
            page: "data.currPage",
            total: "data.totalPage",
            records: "data.totalCount"
        },
        prmNames: {
            page: "page",
            rows: "limit",
            order: "order",
        },
        gridComplete: function () {
            //隐藏grid底部滚动条
            $("#jqGrid").closest(".ui-jqgrid-bdiv").css({"overflow-x": "hidden"});
        }
    });
    $(window).resize(function () {
        $("#jqGrid").setGridWidth($(".card-body").width());
    });
    function statusFormatter(cellvalue) {
        if (cellvalue == 0) {
            return "<button type=\"button\" class=\"btn btn-block btn-secondary btn-sm\" style=\"width: 80%;\">待审核</button>";
        }
        else if (cellvalue == 1) {
            return "<button type=\"button\" class=\"btn btn-block btn-success btn-sm\" style=\"width: 80%;\">已审核</button>";
        }
    }
});
```

以上代码的主要功能为分页数据展示、字段格式化 jqGrid DOM 宽度的自适应，在页面加载时，调用 JqGrid 的初始化方法，将页面中 id 为 jqGrid 的 DOM 渲染为分页表格，并向后端发送请求，请求路径为 **/admin/comments/list**，该路径即友链分页列表接口，之后按照后端返回的 json 数据填充表格以及表格下方的分页按钮，可以参考第 15 个实验课程中 jqgrid 分页功能整合进行知识的理解，之后可以重启项目验证一下评论信息分页功能是否正常。

#### 批量审核功能

游客在博客详情页提交的评论初始状态为未审核，因为这些游客输入的内容有些可能是无意义的字符串或者一些不适合显示的内容，这种就不需要显示在博客页面了，因此做了审核这个功能。 批量审核按钮的点击触发事件为 checkDoneComments()，在 comment.js 文件中新增如下代码：

```
/**
 * 批量审核
 */
function checkDoneComments() {
    var ids = getSelectedRows();
    if (ids == null) {
        return;
    }
    swal({
        title: "确认弹框",
        text: "确认审核通过吗?",
        icon: "warning",
        buttons: true,
        dangerMode: true,
    }).then((flag) => {
            if (flag) {
                $.ajax({
                    type: "POST",
                    url: "/admin/comments/checkDone",
                    contentType: "application/json",
                    data: JSON.stringify(ids),
                    success: function (r) {
                        if (r.resultCode == 200) {
                            swal("审核成功", {
                                icon: "success",
                            });
                            $("#jqGrid").trigger("reloadGrid");
                        } else {
                            swal(r.message, {
                                icon: "error",
                            });
                        }
                    }
                });
            }
        }
    );
}
```

获取用户在 jqgrid 表格中选择的需要审核的所有记录的 id，之后将参数封装并向后端发送 Ajax 请求，请求地址为 comments/checkDone。

#### 回复功能实现

回复按钮绑定了触发事件，我们需要在 comment.js 文件中新增 reply() 方法，方法中的实现为打开信息编辑框，下面我们来实现信息编辑框触发事件，代码如下：

```
<div class="content">
            <!-- 模态框（Modal） -->
            <div class="modal fade" id="replyModal" tabindex="-1" role="dialog" aria-labelledby="replyModalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h6 class="modal-title" id="replyModalLabel">评论回复</h6>
                        </div>
                        <div class="modal-body">
                            <form id="replyForm">
                                <input type="hidden" class="form-control" id="categoryId" name="categoryId">
                                <div class="form-group">
                                    <label for="replyBody" class="control-label">回复内容:</label>
                                    <textarea type="text" class="form-control" id="replyBody" name="replyBody"
                                              placeholder="请输入回复内容" required="true"></textarea>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" id="saveButton">确认</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.modal -->
        </div>
```

回复方法实现如下：

```
function reply() {
    var id = getSelectedRow();
    if (id == null) {
        return;
    }
    var rowData = $("#jqGrid").jqGrid('getRowData', id);
    if (rowData.commentStatus.indexOf('待审核') > -1) {
        swal("请先审核该评论再进行回复!", {
            icon: "warning",
        });
        return;
    }
    $("#replyBody").val('');
    $('#replyModal').modal('show');
}
```

在 Modal 框显示之前首先会判断当前所选择的评论记录的状态，如果未审核是不会显示回复编辑框的，审核通过则显示回复框让管理员添加回复信息。

Modal 框实际效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381697191/wm)

将回复内容填写后点击**确认**按钮即可，此时会进行数据的交互，js 实现代码如下：

```
//绑定modal上的保存按钮
$('#saveButton').click(function () {
    var replyBody = $("#replyBody").val();
    if (!validCN_ENString2_100(replyBody)) {
        swal("请输入符合规范的回复信息!", {
            icon: "warning",
        });
        return;
    } else {
        var url = '/admin/comments/reply';
        var id = getSelectedRow();
        var params = {"commentId": id, "replyBody": replyBody}
        $.ajax({
            type: 'POST',//方法类型
            url: url,
            data: params,
            success: function (result) {
                if (result.resultCode == 200) {
                    $('#replyModal').modal('hide');
                    swal("回复成功", {
                        icon: "success",
                    });
                    reload();
                }
                else {
                    $('#replyModal').modal('hide');
                    swal(result.message, {
                        icon: "error",
                    });
                }
                ;
            },
            error: function () {
                swal("操作失败", {
                    icon: "error",
                });
            }
        });
    }
});
```

获取回复内容字符串以及需要添加回复的评论主键 id ，之后调用回复接口即可。

#### 删除功能

删除按钮的点击触发事件为 deleteComments()，在 comment.js 文件中新增如下代码：

```
/**
 * 批量删除
 */
function deleteComments() {
    var ids = getSelectedRows();
    if (ids == null) {
        return;
    }
    swal({
        title: "确认弹框",
        text: "确认删除这些评论吗?",
        icon: "warning",
        buttons: true,
        dangerMode: true,
    }).then((flag) => {
            if (flag) {
                $.ajax({
                    type: "POST",
                    url: "/admin/comments/delete",
                    contentType: "application/json",
                    data: JSON.stringify(ids),
                    success: function (r) {
                        if (r.resultCode == 200) {
                            swal("删除成功", {
                                icon: "success",
                            });
                            $("#jqGrid").trigger("reloadGrid");
                        } else {
                            swal(r.message, {
                                icon: "error",
                            });
                        }
                    }
                });
            }
        }
    );
}
```

获取用户在 jqgrid 表格中选择的需要删除的所有记录的 id，之后将参数封装并向后端发送 Ajax 请求，请求地址为 comments/delete，删除功能已经开发完成，同学们可以对后台管理系统中的评论管理模块进行功能测试。

接下来是博客详情页关于评论提交以及评论展示的功能开发。

# 评论提交

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381712611/wm)

#### 评论提交接口

评论提交接口主要是为了处理上图中的场景，用户在看完博客后想要留下一些感想或者建议都是通过这个模块来处理的，该接口主要负责接收前端的 POST 请求并处理其中的参数，接收的参数依次为：

1. blogId 字段(当前博客的主键)
2. verifyCode 字段(验证码，防止恶意提交)
3. commentator 字段(称呼)
4. email 字段(邮箱地址)
5. websiteUrl 字段(网站地址，可不填)
6. commentBody 字段(评论内容)

接口的映射地址为 **/blog/comment**，请求方法为 POST，代码如下：

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.blog.MyBlogController.java**）：

  ```
      /**
       * 评论操作
       */
      @PostMapping(value = "/blog/comment")
      @ResponseBody
      public Result comment(HttpServletRequest request, HttpSession session,@RequestParam Long blogId, @RequestParam String verifyCode,@RequestParam String commentator, @RequestParam String email,@RequestParam String websiteUrl, @RequestParam String commentBody) {
          if (StringUtils.isEmpty(verifyCode)) {
              return ResultGenerator.genFailResult("验证码不能为空");
          }
          String kaptchaCode = session.getAttribute("verifyCode") + "";
          if (StringUtils.isEmpty(kaptchaCode)) {
              return ResultGenerator.genFailResult("非法请求");
          }
          if (!verifyCode.equals(kaptchaCode)) {
              return ResultGenerator.genFailResult("验证码错误");
          }
          String ref = request.getHeader("Referer");
          if (StringUtils.isEmpty(ref)) {
              return ResultGenerator.genFailResult("非法请求");
          }
          if (null == blogId || blogId < 0) {
              return ResultGenerator.genFailResult("非法请求");
          }
          if (StringUtils.isEmpty(commentator)) {
              return ResultGenerator.genFailResult("请输入称呼");
          }
          if (StringUtils.isEmpty(email)) {
              return ResultGenerator.genFailResult("请输入邮箱地址");
          }
          if (!PatternUtil.isEmail(email)) {
              return ResultGenerator.genFailResult("请输入正确的邮箱地址");
          }
          if (StringUtils.isEmpty(commentBody)) {
              return ResultGenerator.genFailResult("请输入评论内容");
          }
          if (commentBody.trim().length() > 200) {
              return ResultGenerator.genFailResult("评论内容过长");
          }
          BlogComment comment = new BlogComment();
          comment.setBlogId(blogId);
          comment.setCommentator(MyBlogUtils.cleanString(commentator));
          comment.setEmail(email);
          if (PatternUtil.isURL(websiteUrl)) {
              comment.setWebsiteUrl(websiteUrl);
          }
          comment.setCommentBody(MyBlogUtils.cleanString(commentBody));
          return ResultGenerator.genSuccessResult(commentService.addComment(comment));
      }
  ```

- **com.site.blog.my.core.service.impl.CommentServiceImpl.java**）：

  ```
      public Boolean addComment(BlogComment blogComment) {
          return blogCommentMapper.insertSelective(blogComment) > 0;
      }
  ```

SQL 语句在 BlogMapper.xml 文件中，是自动生成的 SQL，这里就不贴了，评论接口中，首先会对参数进行校验，之后交给业务层代码进行操作最后将评论数据存入数据库中。

#### 评论提交功能制作

首先是在博客详情页 detail.html 添加评论提交的 DOM 元素，代码如下：

```
                <th:block th:if="${blogDetailVO.enableComment==0}">
                    <aside class="create-comment" id="create-comment">
                        <hr>
                        <h2><i class="fa fa-pencil"></i> 添加评论</h2>
                        <form action="#" method="get" onsubmit="return false;" accept-charset="utf-8">
                            <input type="hidden" id="blogId" name="blogId" th:value="${blogDetailVO.blogId}"></input>
                            <div class="row">
                                <div class="col-md-6">
                                    <input type="text" name="commentator" id="commentator" placeholder="(*必填)怎么称呼你?"
                                           class="form-control input-lg">
                                </div>
                                <div class="col-md-6">
                                    <input type="email" name="email" id="email" placeholder="(*必填)你的联系邮箱"
                                           class="form-control input-lg">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <input type="text" name="websiteUrl" id="websiteUrl" placeholder="你的网站地址(可不填)"
                                           class="form-control input-lg">
                                </div>
                                <div class="col-md-6">
                                    <div class="col-md-4">
                                        <img alt="单击图片刷新！" class="pointer" style="margin-top: 15px; border-radius: 25px;"
                                             th:src="@{/common/kaptcha}"
                                             onclick="this.src='/common/kaptcha?d='+new Date()*1">
                                    </div>
                                    <div class="col-md-8">
                                        <input type="text" class="form-control input-lg" name="verifyCode" id="verifyCode"
                                               placeholder="(*必填)请输入验证码"
                                               required="true">
                                    </div>
                                </div>
                            </div>
                            <textarea rows="10" name="commentBody" id="commentBody" placeholder="(*必填)请输入你的评论"
                                      class="form-control input-lg"></textarea>

                            <div class="buttons clearfix">
                                <button type="submit" id="commentSubmit" class="btn btn-xlarge btn-clean-one">提交</button>
                            </div>
                        </form>
                    </aside>
                </th:block>
```

首先是判断当前博客是否允许评论，如果允许则显示下方添加评论的页面元素，否则不显示，接下来是 js 实现评论数据提交的功能介绍。

在 resources/static/blog/js 目录下新增 comment 目录，之后新建 comment.js 和 valid.js，valid.js 中是一些常用的正则验证方法，就不贴在文中了，之后在 detail.html 页面中添加以下代码引入相关静态资源：

```
<!-- sweetalert -->
<link rel="stylesheet" th:href="@{/admin/plugins/sweetalert/sweetalert.css}"/>

<script th:src="@{/blog/js/comment/valid.js}"></script>
<script th:src="@{/blog/js/comment/comment.js}"></script>
```

comment.js 源码如下：

```
$('#commentSubmit').click(function () {
    var blogId = $('#blogId').val();
    var verifyCode = $('#verifyCode').val();
    var commentator = $('#commentator').val();
    var email = $('#email').val();
    var websiteUrl = $('#websiteUrl').val();
    var commentBody = $('#commentBody').val();
    if (isNull(blogId)) {
        swal("参数异常", {
            icon: "warning",
        });
        return;
    }
    if (isNull(commentator)) {
        swal("请输入你的称呼", {
            icon: "warning",
        });
        return;
    }
    if (isNull(email)) {
        swal("请输入你的邮箱", {
            icon: "warning",
        });
        return;
    }
    if (isNull(verifyCode)) {
        swal("请输入验证码", {
            icon: "warning",
        });
        return;
    }
    if (!validCN_ENString2_100(commentator)) {
        swal("请输入符合规范的名称(不要输入特殊字符)", {
            icon: "warning",
        });
        return;
    }
    if (!validCN_ENString2_100(commentBody)) {
        swal("请输入符合规范的评论内容(不要输入特殊字符)", {
            icon: "warning",
        });
        return;
    }
    var data = {
        "blogId": blogId, "verifyCode": verifyCode, "commentator": commentator,
        "email": email, "websiteUrl": websiteUrl, "commentBody": commentBody
    };
    $.ajax({
        type: 'POST',//方法类型
        url: '/blog/comment',
        data: data,
        success: function (result) {
            if (result.resultCode == 200) {
                swal("评论提交成功请等待博主审核", {
                    icon: "success",
                });
                $('#commentBody').val('');
                $('#verifyCode').val('');
            }
            else {
                swal(result.message, {
                    icon: "error",
                });
            }
            ;
        },
        error: function () {
            swal("操作失败", {
                icon: "error",
            });
        }
    });
});
```

主要是监听评论的提交事件，当用户输入完评论信息后会点击提交按钮，此时该 js 就开始起作用了，如上代码所示，首先是获取所有用户输入的内容，之后对这些字符串进行参数校验，验证通过后封装数据并向服务器发送评论提交的请求，接口地址为 **/blog/comment**，之后弹出提醒框告知用户。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381743805/wm)

功能演示如上图所示，一切正常的话这条评论信息应该会存储到数据库中，大家在测试的时候可以看一下数据库，也可以看一下后天管理系统中评论管理页面中是否有这条记录。

# 评论展示

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381760910/wm)

#### 详情功能修改

如上图所示，评论列表区域渲染的数据应该是一个 List 对象，同时下方又有分页按钮则说明后端需要返回的数据是一个 PageResult 对象，因为评论数据是在博客详情页中，所以对详情方法进行修改，添加分页传参，同时返回的数据中增加评论数据，MyBlogController 中的 `detail()` 方法代码修改如下：(**注：完整代码位于 com.site.blog.my.core.controller.blog.MyBlogController**)

```
    /**
     * 详情页
     *
     * @return
     */
    @GetMapping("/blog/{blogId}")
    public String detail(HttpServletRequest request, @PathVariable("blogId") Long blogId, @RequestParam(value = "commentPage", required = false, defaultValue = "1") Integer commentPage) {
        BlogDetailVO blogDetailVO = blogService.getBlogDetail(blogId);
        if (blogDetailVO != null) {
            request.setAttribute("blogDetailVO", blogDetailVO);
            request.setAttribute("commentPageResult", commentService.getCommentPageByBlogIdAndPageNum(blogId, commentPage));
        }
        request.setAttribute("pageName", "详情");
        return "blog/detail";
    }
```

service 层也需要修改，在 CommentService 中新增 `getCommentPageByBlogIdAndPageNum()` 方法用于查询当前博客下的评论分页数据，传参为 `blogId` 和 `pageNum`，源码如下：(**注：完整代码位于 com.site.blog.my.core.service.impl.CommentServiceImpl.java**)

```
    public PageResult getCommentPageByBlogIdAndPageNum(Long blogId, int page) {
        if (page < 1) {
            return null;
        }
        Map params = new HashMap();
        params.put("page", page);
        //每页8条
        params.put("limit", 8);
        params.put("blogId", blogId);//过滤当前博客下的评论数据
        params.put("commentStatus", 1);//过滤审核通过的数据
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        List<BlogComment> comments = blogCommentMapper.findBlogCommentList(pageUtil);
        if (!CollectionUtils.isEmpty(comments)) {
            int total = blogCommentMapper.getTotalBlogComments(pageUtil);
            PageResult pageResult = new PageResult(comments, total, pageUtil.getLimit(), pageUtil.getPage());
            return pageResult;
        }
        return null;
    }
```

具体的 SQL 语句如下（注：完整代码位于 **resources/mapper/BlogCommentMapper.xml**）：****

```
    <select id="findBlogCommentList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog_comment
        where is_deleted=0
        <if test="blogId!=null">
            AND blog_id = #{blogId}
        </if>
        <if test="commentStatus!=null">
            AND comment_status = #{commentStatus}
        </if>
        order by comment_id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalBlogComments" parameterType="Map" resultType="int">
        select count(*) from tb_blog_comment
        where is_deleted=0
        <if test="blogId!=null">
            AND blog_id = #{blogId}
        </if>
        <if test="commentStatus!=null">
            AND comment_status = #{commentStatus}
        </if>
    </select>
```

在原来查询评论列表 SQL 的基础上增加了对于 blog_id 字段和 comment_status 的过滤，后台管理系统中是将所有状态和所有博客下的评论数据都显示出来，而详情页则是当前博客下的且已经被审核通过的评论内容才会被显示在页面中，所以需要对这两个字段进行过滤。

#### 页面展示

最后是博客详情页中评论列表的渲染，在 detail.html 新增如下代码：

```
    <aside class="comments" id="comments">
        <th:block th:if="${null != commentPageResult}">
            <th:block th:each="comment,iterStat : ${commentPageResult.list}">
                <article class="comment">
                    <header class="clearfix">
                        <img th:src="@{/blog/img/avatar.png}" class="avatar">
                        <div class="meta">
                            <h3 th:text="${comment.commentator}"></h3>
                            <span class="date">
                           评论时间：<th:block th:text="${#dates.format(comment.commentCreateTime, 'yyyy-MM-dd HH:mm:ss')}"></th:block>
                        </span>
                        </div>
                    </header>
                    <div class="body">
                        <th:block th:text="${comment.commentBody}"></th:block>
                    </div>
                </article>
                <th:block th:unless="${#strings.isEmpty(comment.replyBody)}">
                    <article class="comment reply">
                        <header class="clearfix">
                            <img th:src="@{/blog/img/avatar.png}"
                                 style="float: left;border-radius: 100px;width: 50px;">
                            <div class="meta2">
                                <h3>十三</h3>
                                <span class="date">
                            回复时间： <th:block th:text="${#dates.format(comment.replyCreateTime, 'yyyy-MM-dd HH:mm:ss')}"></th:block>
                        </span>

                            </div>
                        </header>
                        <div class="reply-body">
                            <th:block th:text="${comment.replyBody}"></th:block>
                        </div>
                    </article>
                </th:block>
            </th:block>
        </th:block>
        <th:block th:if="${null != commentPageResult}">
            <ul class="blog-pagination" style="margin-left: 40%;margin-top:40px;">
                <li th:class="${commentPageResult.currPage==1}?'disabled' : ''"><a
                        th:href="@{${commentPageResult.currPage==1}?'##':'/blog/'+${blogDetailVO.blogId}+'?commentPage=' + ${commentPageResult.currPage-1}+'#comments'}">&laquo;</a>
                </li>
                <li th:if="${commentPageResult.currPage-3 >=1}"><a
                        th:href="@{'/blog/'+${blogDetailVO.blogId}+'?commentPage=' + ${commentPageResult.currPage-3}+'#comments'}"
                        th:text="${commentPageResult.currPage -3}">1</a></li>
                <li th:if="${commentPageResult.currPage-2 >=1}"><a
                        th:href="@{'/blog/'+${blogDetailVO.blogId}+'?commentPage=' + ${commentPageResult.currPage-2}+'#comments'}"
                        th:text="${commentPageResult.currPage -2}">1</a></li>
                <li th:if="${commentPageResult.currPage-1 >=1}"><a
                        th:href="@{'/blog/'+${blogDetailVO.blogId}+'?commentPage=' + ${commentPageResult.currPage-1}}"
                        th:text="${commentPageResult.currPage -1}">1</a></li>
                <li class="active"><a href="#" th:text="${commentPageResult.currPage}">1</a></li>
                <li th:if="${commentPageResult.currPage+1 <=commentPageResult.totalPage}"><a
                        th:href="@{'/blog/'+${blogDetailVO.blogId}+'?commentPage=' + ${commentPageResult.currPage+1}+'#comments'}"
                        th:text="${commentPageResult.currPage +1}">1</a></li>
                <li th:if="${commentPageResult.currPage+2 <=commentPageResult.totalPage}"><a
                        th:href="@{'/blog/'+${blogDetailVO.blogId}+'?commentPage=' + ${commentPageResult.currPage+2}+'#comments'}"
                        th:text="${commentPageResult.currPage +2}">1</a></li>
                <li th:if="${commentPageResult.currPage+3 <=commentPageResult.totalPage}"><a
                        th:href="@{'/blog/'+${blogDetailVO.blogId}+'?commentPage=' + ${commentPageResult.currPage+3}+'#comments'}"
                        th:text="${commentPageResult.currPage +3}">1</a></li>
                <li th:class="${commentPageResult.currPage==commentPageResult.totalPage}?'disabled' : ''"><a
                        th:href="@{${commentPageResult.currPage==commentPageResult.totalPage}?'##' : '/blog/'+${blogDetailVO.blogId}+'?commentPage=' + ${commentPageResult.currPage+1}+'#comments'}">&raquo;</a>
                </li>
            </ul>
        </th:block>
    </aside>
```

在评论列表区域和分页功能区域对应的位置读取 commentPageResult 对象中的 list 数据和分页数据，list 数据为评论列表数据，使用 `th:each` 循环语法将评论内容、评论时间、回复内容、回复时间等字段渲染出来，之后根据分页字段 currPage(当前页码)、 totalPage(总页码)将下方的分页按钮渲染出来，分页按钮生成的逻辑与前几个实验中首页博客列表和搜索页博客列表中的逻辑类似，区别在于跳转链接的最后加上了 **#comments**。

这里解释一下这么做的含义，首先，评论列表是在博客详情页中且位置一般是在页面下方，如果文字过多可能需要往下拉很多屏 才能看到评论数据，但是翻页的 URL 还是 **/blog/{blogId}**，所以每次跳转都是到详情页，本来是想看第二页或者第三页的评论数据，结果点击分页按钮后跳到了详情页的上方，虽然第三页评论的数据渲染出来了，但是却需要再往下拉个几屏才行，因此就将评论列表的 DOM 对象设置了 **comments** 作为 DOM id，跳转链接的最后加上 **#comments** 就可以通过锚点的方式跳到评论列表区域。

# 总结

这节实验的内容有些多，看了一下内容长度大概是平时两个实验课程的长度，同学们可以分成两个实验来学习也可以，因为课程安排如此不好再更改，因此评论模块的所有知识点都放在一个实验中进行讲解了。同学们可以按照文中的思路和过程自行测试，本次实验完成！

评论模块的开发是整个项目的最后一部分了，至此，博客系统的所有主要模块都已经开发完成，包括其中的功能和页面都在各个实验中进行了讲解和开发，剩下的一些小功能比较简单就不再浪费篇幅了，因为这些内容都是查询功能并没有特别复杂的逻辑。

另外，还有一点需要提醒同学们，**目前所有课程中的源码都是开发过程中的代码，是供大家练习和理解课程内容的，如果想要可以真实上线的代码可以到我的 GitHub 仓库中获取，地址是 https://github.com/ZHENFENG13/My-Blog，备用地址是 https://gitee.com/zhenfeng13/My-Blog**，这里的代码都是可以直接打包上线。当然，该博客项目也在持续更新中，如果大家有什么建议都可以告诉我，**我会继续对这个项目进行迭代和完善，记住上方两个仓库地址，可上线的完整代码我都会第一时间更新上去，如果还有其他课程问题也可以添加课程 QQ 群 796794009，我会在里面进行解答。**