# 实验介绍

#### 实验内容

本节实验将会对博客的友情链接管理模块进行介绍和功能开发及完善。

#### 实验知识点

- 友情链接模块介绍
- 友情链接模块表结构设计及接口实现
- 友情链接模块页面设计及编码
- 友情链接功能测试

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-24.zip
unzip My-Blog-24.zip
cd My-Blog
```

# 友情链接模块简介

友情链接是具有一定资源互补优势的网站之间的简单合作形式，即分别在自己的网站上放置对方网站的 LOGO 图片或文字的网站名称，并设置对方网站的超链接使得用户可以从合作网站中发现自己的网站，达到互相推广的目的，因此常作为一种网站推广基本手段。友情链接是指互相在自己的网站上放对方网站的链接。必须要能在网页代码中找到网址和网站名称，而且浏览网页的时候能显示网站名称，这样才叫友情链接。

以下为部分博客网站的友情链接模块：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380115610/wm)

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380125018/wm)

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380134255/wm)

通常来说，友情链接交换的意义主要体现在如下几方面：

- **提升网站流量**
- **完善用户体验**
- **增加网站外链**
- **提高关键字排名**
- **提高网站权重**
- **提高知名度**

自建的技术博客网站毕竟是私人网站，流量和关注度肯定不会特别高，通过友情链接的设置可以增加一些流量，这也是大部分技术博客中不可缺少的一个元素，基本上每个博主都会设置友情链接。

# 表结构设计及 Mapper 文件自动生成

#### 表结构设计

在进行接口设计和具体的功能实现前，首先将表结构确定下来，根据前文中几张友情链接模块的图片我们可以发现，该模块也只是用作展示使用，其中有三个字段是非常重要的，依次为：

- 友情链接的名称
- 友情链接的跳转链接
- 友情链接的简单描述

基于此友情链接表的 SQL 设计如下，直接执行如下 SQL 语句即可：

```
USE `my_blog_db`;
DROP TABLE IF EXISTS `tb_link`;
CREATE TABLE `tb_link` (
  `link_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '友链表主键id',
  `link_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '友链类别 0-友链 1-推荐 2-个人网站',
  `link_name` varchar(50) NOT NULL COMMENT '网站名称',
  `link_url` varchar(100) NOT NULL COMMENT '网站链接',
  `link_description` varchar(100) NOT NULL COMMENT '网站描述',
  `link_rank` int(11) NOT NULL DEFAULT '0' COMMENT '用于列表排序',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否删除 0-未删除 1-已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

友情链接表的字段以及每个字段对应的含义都在上面的 SQL 中有介绍，大家可以对照 SQL 进行理解，在三个基础字段的基础上又添加了友链类别 link_type 字段，因为有些链接是个人网站，为了更好的区分友链就加了此字段，把表结构导入到数据库中即可，接下来我们进行编码工作。

# MyBatis-Generator 插件自动生成 Mapper 文件

首先，我们使用 MyBatis-Generator 插件将该表对应的 Mapper 文件及对应的实体类和 Dao 层接口生成出来，这部分代码就不贴在文章中了，大家可以通过下载源码来查看。

需要注意的是，在代码生成后需要在 dao 层下的 BlogLinkMapper 接口类上添加 @Mapper 注解以将其注册到 IOC 容器中以供后续调用（如果已经在主类上添加 @MapperScan 注解这一步可以省略）。其次，在 tb_link 表中，我们设计了一个 is_deleted 字段，用于逻辑删除的标志位，由于 is_deleted 的字段设计，我们对表中数据的删除都是软删除，而不是真正意义的删除，只是做了一个删除标志位，如果此字段为 1 则表示已经被删除不再使用，因为是个人博客，这么做的目的主要也是为了防止误删，因此我们需要修改 Mapper 文件中的 查询语句和删除语句，将 is_deleted 条件带上，修改后的语句如下：(**注：完整代码位于 resources/mapper/BlogLinkMapper.xml**)

```
    <select id="selectByPrimaryKey" parameterType="java.lang.Integer" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_link
        where link_id = #{linkId,jdbcType=INTEGER} AND is_deleted = 0
    </select>

    <update id="deleteByPrimaryKey" parameterType="java.lang.Integer">
    UPDATE tb_link SET is_deleted = 1
    where link_id = #{linkId,jdbcType=INTEGER} AND is_deleted = 0
    </update>
```

通过以上代码我们可以看出，在删除操作时我们并不是执行 delete 语句，而是将需要删除的这条记录的 is_deleted 字段修改为 1，这样就表示该行记录已经被执行了删除操作，那么其他的 select 查询语句就需要在查询条件中添加 `is_deleted = 0` 将“被删除”的记录给过滤出去，这个知识点希望大家能够理解，在后续的其他功能模块中我们也会使用软删除的设计。

# 友情链接管理页面制作

#### 导航栏

首先在左侧导航栏中新增友情链接管理页的导航按钮，在 sidebar.html 文件中新增如下代码：(**注：完整代码位于 resources/templates/admin/sidebar.html**)

```
    <li class="nav-item">
        <a th:href="@{/admin/links}" th:class="${path}=='links'?'nav-link active':'nav-link'">
            <i class="fa fa-heart nav-icon" aria-hidden="true"></i>
            <p>
                友情链接
            </p>
        </a>
    </li>
```

点击后的跳转路径为 /admin/links，之后我们新建 Controller 来处理该路径并跳转到对应的页面。

# Controller 处理跳转

首先在 controller/admin 包下新建 LinkController.java，之后新增如下代码：

```
package com.site.blog.my.core.controller.admin;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletRequest;
@Controller
@RequestMapping("/admin")
public class LinkController {

    @GetMapping("/links")
    public String linkPage(HttpServletRequest request) {
        request.setAttribute("path", "links");
        return "admin/link";
    }
}
```

该方法用于处理 /admin/links 请求，并设置 path 字段，之后跳转到 admin 目录下的 link.html 中。

# link.html 页面制作

接下来就是博客编辑页面的模板文件制作了，在 resources/templates/admin 目录下新建 link.html，并引入对应的 js 文件和 css 样式文件，代码如下：

```
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
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
                        <h3 class="card-title">友情链接管理</h3>
                    </div> <!-- /.card-body -->
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

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380157405/wm)

# 友情链接模块接口设计及实现

#### 接口介绍

关于接口的设计以及前后端交互数据的设计大家可以参考一下第 10 课中的内容，友链模块在后台管理系统中有 5 个接口，分别是：

- 友链列表分页接口
- 添加友链接口
- 根据 id 获取单条友链记录接口
- 修改友链接口
- 删除友链接口

接下来讲解每个接口具体的实现代码，首先在 controller/admin 包下新建 LinkController.java，并在 service 包下新建业务层代码 LinkService.java 及实现类，之后参照接口分别进行功能实现。

# 友情链接列表分页接口

列表接口负责接收前端传来的分页参数，如 page 、limit 等参数，之后将数据总数和对应页面的数据列表查询出来并封装为分页数据返回给前端。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.LinkController.java**）：

接口的映射地址为 /links/list，请求方法为 GET，代码如下：

```
    /**
     * 友链列表
     */
    @GetMapping("/links/list")
    @ResponseBody
    public Result list(@RequestParam Map<String, Object> params) {
        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(linkService.getBlogLinkPage(pageUtil));
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.LinkServiceImpl.java**）：

```
    public PageResult getBlogLinkPage(PageQueryUtil pageUtil) {
        List<BlogLink> links = blogLinkMapper.findLinkList(pageUtil);
        int total = blogLinkMapper.getTotalLinks(pageUtil);
        PageResult pageResult = new PageResult(links, total, pageUtil.getLimit(), pageUtil.getPage());
        return pageResult;
    }
```

- BlogLinkMapper.xml （注：完整代码位于 **resources/mapper/BlogLinkMapper.xml**）：

```
    <select id="findLinkList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_link
        where is_deleted=0
        order by link_id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalLinks" parameterType="Map" resultType="int">
        select count(*)  from tb_link
        where is_deleted=0
    </select>
```

SQL 语句在 BlogLinkMapper.xml 文件中，一般的分页也就是使用 `limit` 关键字实现，获取响应条数的记录和总数之后再进行数据封装，这个接口就是根据前端传的分页参数进行查询并返回分页数据以供前端页面进行数据渲染。

# 添加友链接口

添加接口负责接收前端的 POST 请求并处理其中的参数，接收的参数依次为：

1. linkType 字段(友链类型)
2. linkName 字段(友链名称)
3. linkUrl 字段(友链的跳转链接)
4. linkRank 字段(排序值)
5. linkDescription 字段(友链简介)

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.LinkController.java**）：

接口的映射地址为 /links/save，请求方法为 POST，代码如下：

```
    /**
     * 友链添加
     */
    @RequestMapping(value = "/links/save", method = RequestMethod.POST)
    @ResponseBody
    public Result save(@RequestParam("linkType") Integer linkType,
                       @RequestParam("linkName") String linkName,
                       @RequestParam("linkUrl") String linkUrl,
                       @RequestParam("linkRank") Integer linkRank,
                       @RequestParam("linkDescription") String linkDescription) {
        if (linkType == null || linkType < 0 || linkRank == null || linkRank < 0 || StringUtils.isEmpty(linkName) || StringUtils.isEmpty(linkName) || StringUtils.isEmpty(linkUrl) || StringUtils.isEmpty(linkDescription)) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        BlogLink link = new BlogLink();
        link.setLinkType(linkType.byteValue());
        link.setLinkRank(linkRank);
        link.setLinkName(linkName);
        link.setLinkUrl(linkUrl);
        link.setLinkDescription(linkDescription);
        return ResultGenerator.genSuccessResult(linkService.saveLink(link));
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.LinkServiceImpl.java**）：

```
    public Boolean saveLink(BlogLink link) {
        return blogLinkMapper.insertSelective(link) > 0;
    }
```

SQL 语句在 BlogLinkMapper.xml 文件中，是自动生成的 SQL，这里就不贴了。添加接口中，首先会对参数进行校验，之后交给业务层代码进行操作。

# 删除友情链接接口

删除接口负责接收前端的友情链接删除请求，处理前端传输过来的数据后，将这些记录从数据库中删除，这里的“删除”功能并不是真正意义上的删除，而是逻辑删除，我们将接受的参数设置为一个数组，可以同时删除多条记录，只需要在前端将用户选择的记录 id 封装好再传参到后端即可。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.LinkController.java**）：

接口的映射地址为 /links/delete，请求方法为 POST，代码如下：

```
    /**
     * 友链删除
     */
    @RequestMapping(value = "/links/delete", method = RequestMethod.POST)
    @ResponseBody
    public Result delete(@RequestBody Integer[] ids) {
        if (ids.length < 1) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        if (linkService.deleteBatch(ids)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("删除失败");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.LinkServiceImpl.java**）：

```
    public Boolean deleteBatch(Integer[] ids) {
        return blogLinkMapper.deleteBatch(ids) > 0;
    }
```

- BlogLinkMapper.xml （注：完整代码位于 **resources/mapper/BlogLinkMapper.xml**）：

```
    <update id="deleteBatch">
        update tb_link
        set is_deleted=1 where link_id in
        <foreach item="id" collection="array" open="(" separator="," close=")">
            #{id}
        </foreach>
    </update>
```

接口的请求路径为 /links/delete，并使用 @RequestBody 将前端传过来的参数封装为 id 数组，参数验证通过后则调用 deleteBatch() 批量删除方法进行数据库操作，否则将向前端返回错误信息。

# 其它

还有根据 id 获取详情的接口，路径为 links/info/{id}，请求方法为 GET；修改接口，路径为 links/update，请求方法为 POST。在接口设计和实现完成后，需要对接口进行测试，如果出现问题立刻修复，以上这些代码我都已经编写完成并将代码以压缩包的形式提供，大家在学习时可以直接使用我给的代码进行练习。

# 前端页面实现

#### 功能按钮

友情链接管理模块我们也设计了常用的几个功能：友链信息增加、友链信息编辑、友链信息删除，因此在页面中添加对应的功能按钮以及触发事件，代码如下：(**注：完整代码位于 resources/templates/admin/link.html**)

```
<div class="grid-btn">
    <button class="btn btn-info" onclick="linkAdd()"><i class="fa fa-plus"></i>&nbsp;新增
    </button>
    <button class="btn btn-info" onclick="linkEdit()"><i class="fa fa-pencil-square-o"></i>&nbsp;修改</button>
    <button class="btn btn-danger" onclick="deleteLink()"><i class="fa fa-trash-o"></i>&nbsp;删除</button>
</div>
```

分别是添加按钮对应的触发事件是 `linkAdd()` 方法，修改按钮对应的触发事件是 `linkEdit()` 方法，删除按钮对应的触发事件是 `deleteLink()` 方法，这些方法我们将在后续的代码实现中给出。

# 分页信息展示区域

页面中已经引入 JqGrid 的相关静态资源文件，需要在页面中展示分页数据的区域增加如下代码：

```
<table id="jqGrid" class="table table-bordered"></table>
<div id="jqGridPager"></div>
```

# 页面效果

那么最终的静态页面效果展示如下图所示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380189161/wm)

包括功能按钮、数据列表展示区域以及翻页功能区域，此时只是静态效果展示，并没有与后端进行数据交互，接下来我们将结合 Ajax 和后端接口实现具体的功能。

# 友情链接管理模块前端功能实现

完成了页面展示的实现，接着完成相关的功能实现。请大家一定自行对照源码完成代码编写。

# 分页功能

在 resources/static/admin/dist/js 目录下新增 link.js 文件，并添加如下代码：

```
$(function () {
    $("#jqGrid").jqGrid({
        url: '/admin/links/list',
        datatype: "json",
        colModel: [
            {label: 'id', name: 'linkId', index: 'linkId', width: 50, key: true, hidden: true},
            {label: '网站名称', name: 'linkName', index: 'linkName', width: 100},
            {label: '网站链接', name: 'linkUrl', index: 'linkUrl', width: 120},
            {label: '网站描述', name: 'linkDescription', index: 'linkDescription', width: 120},
            {label: '排序值', name: 'linkRank', index: 'linkRank', width: 30},
            {label: '添加时间', name: 'createTime', index: 'createTime', width: 100}
        ],
        height: 560,
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
});
```

以上代码的主要功能为分页数据展示、字段格式化 jqGrid DOM 宽度的自适应，在页面加载时，调用 JqGrid 的初始化方法，将页面中 id 为 jqGrid 的 DOM 渲染为分页表格，并向后端发送请求，请求路径为 **/admin/links/list**，该路径即友链分页列表接口，之后按照后端返回的 json 数据填充表格以及表格下方的分页按钮，可以参考第 15 个实验课程中 jqgrid 分页功能整合进行知识的理解，之后可以重启项目验证一下友情链接信息分页功能是否正常。

# 按钮事件及 Modal 框实现

添加和修改两个按钮分别绑定了触发事件，我们需要在 link.js 文件中新增 `linkAdd()` 方法和 `linkEdit()` 方法，两个方法中的实现为打开信息编辑框，下面我们来实现信息编辑框和两个触发事件，代码如下：(**注：完整代码位于 resources/static/admin/dist/js/link.js**)

```
<div class="content">
    <!-- 模态框（Modal） -->
    <div class="modal fade" id="linkModal" tabindex="-1" role="dialog" aria-labelledby="linkModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h6 class="modal-title" id="linkModalLabel">Modal</h6>
                </div>
                <div class="modal-body">
                    <form id="linkForm">
                        <div class="form-group">
                            <div class="alert alert-danger" id="edit-error-msg" style="display: none;">
                                错误信息展示栏。
                            </div>
                        </div>
                        <input type="hidden" class="form-control" id="linkId" name="linkId">
                        <div class="form-group">
                            <label for="linkType" class="control-label">友链类型:</label>
                            <select class="form-control" id="linkType" name="linkType">
                                <option selected="selected" value="0">友链</option>
                                <option value="1">推荐网站</option>
                                <option value="2">个人链接</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="linkName" class="control-label">网站名称:</label>
                            <input type="text" class="form-control" id="linkName" name="linkName"
                                   placeholder="请输入网站名称" required="true">
                        </div>
                        <div class="form-group">
                            <label for="linkUrl" class="control-label">网站链接:</label>
                            <input type="url" class="form-control" id="linkUrl" name="linkUrl"
                                   placeholder="请输入网站链接" required="true">
                        </div>
                        <div class="form-group">
                            <label for="linkDescription" class="control-label">网站描述:</label>
                            <input type="url" class="form-control" id="linkDescription" name="linkDescription"
                                   placeholder="请输入网站描述" required="true">
                        </div>
                        <div class="form-group">
                            <label for="linkRank" class="control-label">排序值:</label>
                            <input type="number" class="form-control" id="linkRank" name="linkRank"
                                   placeholder="请输入排序值" required="true">
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

`linkAdd()` 方法和 `linkEdit()` 方法实现如下：(**注：完整代码位于 resources/static/admin/dist/js/link.js**)

```
function linkAdd() {
    reset();
    $('.modal-title').html('友链添加');
    $('#linkModal').modal('show');
}

function linkEdit() {
    var id = getSelectedRow();
    if (id == null) {
        return;
    }
    reset();
    //请求数据
    $.get("/admin/links/info/" + id, function (r) {
        if (r.resultCode == 200 && r.data != null) {
            //填充数据至modal
            $("#linkName").val(r.data.linkName);
            $("#linkUrl").val(r.data.linkUrl);
            $("#linkDescription").val(r.data.linkDescription);
            $("#linkRank").val(r.data.linkRank);
            //根据原linkType值设置select选择器为选中状态
            if (r.data.linkType == 1) {
                $("#linkType option:eq(1)").prop("selected", 'selected');
            }
            if (r.data.linkType == 2) {
                $("#linkType option:eq(2)").prop("selected", 'selected');
            }
        }
    });
    $('.modal-title').html('友链修改');
    $('#linkModal').modal('show');
    $("#linkId").val(id);
}
```

添加方法仅仅是将 Modal 框显示，修改功能则多了一个步骤，需要将选择的记录回显到编辑框中以供修改，因此需要请求 links/info/{id} 详情接口获取被修改的友情链接数据信息。

Modal 框实际效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380206598/wm)

将所有信息正确填写后点击**确认**按钮即可。

# 添加功能和编辑功能

在信息录入完成后可以点击信息编辑框下方的**确认**按钮，此时会进行数据的交互，js 实现代码如下：(**注：完整代码位于 resources/static/admin/dist/js/link.js**)

```
//绑定modal上的保存按钮
$('#saveButton').click(function () {
    var linkId = $("#linkId").val();
    var linkName = $("#linkName").val();
    var linkUrl = $("#linkUrl").val();
    var linkDescription = $("#linkDescription").val();
    var linkRank = $("#linkRank").val();
    if (!validCN_ENString2_18(linkName)) {
        $('#edit-error-msg').css("display", "block");
        $('#edit-error-msg').html("请输入符合规范的名称！");
        return;
    }
    if (!isURL(linkUrl)) {
        $('#edit-error-msg').css("display", "block");
        $('#edit-error-msg').html("请输入符合规范的网址！");
        return;
    }
    if (!validCN_ENString2_100(linkDescription)) {
        $('#edit-error-msg').css("display", "block");
        $('#edit-error-msg').html("请输入符合规范的描述！");
        return;
    }
    if (isNull(linkRank) || linkRank < 0) {
        $('#edit-error-msg').css("display", "block");
        $('#edit-error-msg').html("请输入符合规范的排序值！");
        return;
    }
    var params = $("#linkForm").serialize();
    var url = '/admin/links/save';
    if (linkId != null && linkId > 0) {
        url = '/admin/links/update';
    }
    $.ajax({
        type: 'POST',//方法类型
        url: url,
        data: params,
        success: function (result) {
            if (result.resultCode == 200 && result.data) {
                $('#linkModal').modal('hide');
                swal("保存成功", {
                    icon: "success",
                });
                reload();
            }
            else {
                $('#linkModal').modal('hide');
                swal("保存失败", {
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

由于传参和后续处理逻辑类似，为了避免太多重复代码因此将修改友链信息和添加友链信息两个方法写在一起了，通过 id 是否大于 0 来确定是修改操作还是添加操作，方法步骤如下：

1. 前端对用户输入的数据进行简单的正则验证
2. 封装数据
3. 向对应的后端接口发送 Ajax 请求
4. 请求成功后提醒用户请求成功并隐藏当前的信息编辑框，同时刷新列表数据
5. 请求失败则提醒对应的错误信息

# 删除功能

删除按钮的点击触发事件为 deleteLink()，在 link.js 文件中新增如下代码：(**注：完整代码位于 resources/static/admin/dist/js/link.js**)

```
function deleteLink() {
    var ids = getSelectedRows();
    if (ids == null) {
        return;
    }
    swal({
        title: "确认弹框",
        text: "确认要删除数据吗?",
        icon: "warning",
        buttons: true,
        dangerMode: true,
    }).then((flag) => {
            if (flag) {
                $.ajax({
                    type: "POST",
                    url: "/admin/links/delete",
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

获取用户在 jqgrid 表格中选择的需要删除的所有记录的 id，之后将参数封装并向后端发送 Ajax 请求，请求地址为 links/delete，删除功能已经开发完成，同学们可以结合源码以及实际的功能进行学习和理解，接下来我们来进行功能测试。

# 功能测试

我们提供的整个项目的完整代码，请大家下载并参照源码对比学习了解各个功能模块的代码内容。

# 启动 MySQL 并新增 tb_link 表

**如果 MySQL 数据库服务没有启动的话需要进行这一步操作。**

进入实验楼线上开发环境，首先打开一个命令窗口，点击 File -> Open New Terminal 即可，之后在命令行中输入以下命令：

```
sudo service mysql start
```

因为用户权限的关系，需要增加在命令前增加 sudo 取得 root 权限，不然在启动时会报错，之后等待 MySQL 正常启动即可。

之后执行如下命令登陆 MySQL 数据库：

```
sudo mysql -u root 
```

因为实验楼线上实验环境中 MySQL 数据库默认并没有设置密码，因此以上命令即可完成登陆，最后在命令行中执行前文给出的建表语句 SQL 即可。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380224605/wm)

# 启动项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到已解压的 My-Blog 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 mvn spring-boot:run ，之后就可以等待项目启动。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380234923/wm)

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果，之后会在浏览器中弹出 `https://********.simplelab.cn` 访问页面：`https://********.simplelab.cn/admin/login` 并登陆至后台管理首页，之后点击友情链接管理就可以对相关功能进行测试了，演示过程如下。

- 添加功能：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380250509/wm)

- 修改功能：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380264006/wm)

- 删除功能：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380276494/wm)

同学们可以按照文中的思路和过程自行测试，本次实验完成！

