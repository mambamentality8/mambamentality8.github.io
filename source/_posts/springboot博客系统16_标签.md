# 实验介绍

#### 实验内容

本篇继续来完善后台的功能模块，在讲解和开发文章模块前，先将它的相关的属性和必须关联的关系实体讲解和开发完，前一个实验我们将分类模块开发完成，本节实验将会对博客的标签模块进行介绍和功能开发及完善，以便接下来文章模块的讲解和开发。

#### 实验知识点

- 侧边导航栏抽取
- 标签模块表结构设计及接口实现
- 标签模块页面设计及编码
- 标签模块功能测试

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-20.zip
unzip My-Blog-20.zip
cd My-Blog
```

# 侧边栏抽取

部分同学可能对 templates/admin 目录下的 sidebar.html 文件有些疑惑，由于篇幅限制，所以没有在前一个实验中对这个知识点做介绍，这里简单的用一个段落来讲解一下这个知识点，首先告诉大家的是，这个模板文件是抽取出来的左侧导航栏文件，由于每个页面都需要加上侧边导航栏的代码，为了精简代码就将这部分代码提取出来作为公共代码，代码简化的同时，也方便维护和修改，代码如下：(**注：完整代码位于 resources/templates/admin/sidebar.html**)

```
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<aside th:fragment="sidebar-fragment(path)" class="main-sidebar sidebar-dark-primary elevation-4">
    <a th:href="@{/admin/index}" class="brand-link">
        <img th:src="@{/admin/dist/img/logo.png}" alt="ssm-cluster Logo" class="brand-image img-circle elevation-3"
             style="opacity: .8">
        <span class="brand-text font-weight-light">my blog</span>
    </a>
    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Sidebar user panel (optional) -->
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="image">
                <img th:src="@{/admin/dist/img/avatar5.png}" class="img-circle elevation-2" alt="User Image">
            </div>
            <div class="info">
                <a href="#" class="d-block" th:text="${session.loginUser}"></a>
            </div>
        </div>
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu"
                data-accordion="false">
                <!-- Add icons to the links using the .nav-icon class
                     with font-awesome or any other icon font library -->
                <li class="nav-header">Dashboard</li>
                <li class="nav-item">
                    <a th:href="@{/admin/index}" th:class="${path}=='index'?'nav-link active':'nav-link'">
                        <i class="nav-icon fa fa-dashboard"></i>
                        <p>
                            Dashboard
                        </p>
                    </a>
                </li>
                <li class="nav-header">管理模块</li>
                <li class="nav-item">
                    <a th:href="@{/admin/categories}" th:class="${path}=='categories'?'nav-link active':'nav-link'">
                        <i class="fa fa-bookmark nav-icon" aria-hidden="true"></i>
                        <p>
                            分类管理
                        </p>
                    </a>
                </li>
                <li class="nav-item">
                    <a th:href="@{/admin/tags}" th:class="${path}=='tags'?'nav-link active':'nav-link'">
                        <i class="fa fa-tags nav-icon" aria-hidden="true"></i>
                        <p>
                            标签管理
                        </p>
                    </a>
                </li>
                <li class="nav-header">系统管理</li>
                <li class="nav-item">
                    <a th:href="@{/admin/profile}"
                       th:class="${path}=='profile'?'nav-link active':'nav-link'">
                        <i class="fa fa-user-secret nav-icon"></i>
                        <p>修改密码</p>
                    </a>
                </li>
                <li class="nav-item">
                    <a th:href="@{/admin/logout}" class="nav-link">
                        <i class="fa fa-sign-out nav-icon"></i>
                        <p>安全退出</p>
                    </a>
                </li>
                </li>
            </ul>
        </nav>
    </div>
</aside>
</html>
```

页面效果如下图所示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378971326/wm)

接下来解释一下具体的实现逻辑，首先，以上这部分代码如果不进行抽取的话，我们在添加其他模块的时候需要在每一个模块的页面代码中添加一遍，但是基本上所有的代码都是重复的，只有一处不同，那就是导航栏中当前模块的选中状态，比如在分类管理页面中，左侧导航栏中的“分类管理”即为选中状态，其他页面与此相同。

这里的实现方式是通过添加一个 path 变量来控制当前导航栏中的选中状态，在模板文件中的 Thymeleaf 判断语句中通过 path 字段来确定是哪个功能模块，并对应的将左侧导航栏上当前模块的 css 样式给修改掉，判断语句如下：

```
th:class="${path}=='categories'?'nav-link active':'nav-link'"
```

如果当前的 path 字段值为 'categories'，那么“分类管理”这个选项的 css 样式就修改为选中状态，如果当前的 path 字段值为 'tags'，那么“标签管理”这个选项的 css 样式就修改为选中状态，其他模块依次类推，path 字段的值是在哪里进行赋值的呢？答案是 admin 包下的 Controller 类中，在进行页面跳转时，会分别将对应的 path 字段进行赋值，代码如下：

- TagController(**注：完整代码位于 com.site.blog.my.core.controller.admin.TagController.java**)

```
    @GetMapping("/tags")
    public String tagPage(HttpServletRequest request) {
        request.setAttribute("path", "tags");
        return "admin/tag";
    }
```

- CategoryController (**注：完整代码位于 com.site.blog.my.core.controller.admin.CategoryController.java**)

```
    @GetMapping("/categories")
    public String categoryPage(HttpServletRequest request) {
        request.setAttribute("path", "categories");
        return "admin/category";
    }
```

通过这种方式，以后如果需要在系统中新增一个模块，就可以对应的增加一个导航栏按钮在 sidebar.html 文件中，并在后端的控制器方法中赋值对应的 path 字段即可，比如博客管理、配置管理等之后的功能模块。

# 标签模块简介

标签是一种更为灵活、更有趣的分类方式，在书写博客时可以为每篇文章添加一个或多个标签，在博客系统中，文章的标签设计被广泛应用，我们可以看到大部分的博客网站中都会有标签设计，因此，在设计 personal-blog 这个项目时，也将标签运用了进来。

标签最明显的作用有如下两点：

- 一是传统意义上分类的作用，类似分类名称
- 二是对文章内容进行一定程度的描述，类似于关键词

虽然与分类设计类似，但是标签和分类还有一些细区别：

- 同一篇文章标签可以用多个，但通常只能属于一个分类
- 标签一般是在写作完成后，根据文章内容自行添加的内容
- 标签可以把文章中重点词语提炼出来，有关键词的意义，但是分类没有
- 标签通常更为主观，其内容相较于分类来说更加具体一些

与分类的功能和设计思想类似，但是又有一定的不同，标签可以算是分类的细化版本，同时，一篇博客的分类最好只有一个，但是在设计的时候，一篇博客的标签是可以有多个的，标签设计的介绍就到这里，接下来是功能开发的讲解。

# 表结构设计及 Mapper 文件自动生成

#### 标签与文章的关系

通过前文中标签设计的介绍我们也大致的了解了标签与文章的关系，一篇文章可以有多个标签字段，一个标签字段也可以被标注在多个文章中，这个情况与前一个实验中的分类设计是有一些差别的，标签实体与文章实体的关系是多对多的关系，因此在表结构设计时不仅仅需要标签实体和文章实体的字段映射，还需要存储二者之间的关系数据，本系统采用的方式是新增一张关系表来维护二者多对多的关联关系。

# 表结构设计

标签表以及标签文章关系表的 SQL 设计如下，直接执行如下 SQL 语句即可：

```
USE `my_blog_db`;

DROP TABLE IF EXISTS `tb_blog_tag`;

CREATE TABLE `tb_blog_tag` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标签表主键id',
  `tag_name` varchar(100) NOT NULL COMMENT '标签名称',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否删除 0=否 1=是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tb_blog_tag_relation`;

CREATE TABLE `tb_blog_tag_relation` (
  `relation_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关系表id',
  `blog_id` bigint(20) NOT NULL COMMENT '博客id',
  `tag_id` int(11) NOT NULL COMMENT '标签id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`relation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

两张表的字段以及每个字段对应的含义都在上面的 SQL 中有介绍，大家可以对照 SQL 进行理解，在关系表中有一个 blog_id 字段，是文章表的主键 id，虽然暂时还没有介绍文章模块，但是大家应该能够理解关系表存放的字段含义，这张表存储的就是标签记录对应的文章记录，以多对多的方式进行记录的，把表结构导入到数据库中即可，接下来我们进行编码工作。

另外，需要在这里提醒大家，标签表以及关系表的大部分的实现逻辑是在后续文章管理模块中进行调用和实现的，本实验仅仅介绍后台管理系统中的内容，所以不要觉得这两张表意义不大。

# MyBatis-Generator 插件自动生成 Mapper 文件

首先，我们使用 MyBatis-Generator 插件将两张表对应的 Mapper 文件及对应的实体类和 Dao 层接口生成出来，这部分代码就不贴在文章中了，大家可以通过下载源码来查看。

需要注意的是，在代码生成后需要在 dao 层下的 BlogTagMapper接口类和 BlogTagRelationMapper 接口类上添加 @Mapper 注解以将其注册到 IOC 容器中以供后续调用（如果已经在主类上添加 @MapperScan 注解这一步可以省略），生成的 Mapper 文件也需要对应的修改，因为使用的是软删除设计，所以需要在生成的 SQL 语句中对应的加上 is_deleted 字段的逻辑，is_deleted 字段在前文中也已经有详细的介绍，这里就不再赘述。

# 标签模块接口设计及实现

#### 接口介绍

标签模块的大部分实现逻辑是在维护文章表时处理的，后台管理系统中标签模块的功能比较简单，标签模块在后台管理系统中有 3 个接口，分别是：

- 列表分页接口
- 添加标签接口
- 删除标签接口

接下来讲解每个接口具体的实现代码，首先在 controller/admin 包下新建 TagController.java，并在 service 包下新建业务层代码 TagService.java 及实现类，之后参照接口分别进行功能实现。

# 标签列表分页接口

列表接口负责接收前端传来的分页参数，如 page 、limit 等参数，之后将数据总数和对应页面的数据列表查询出来并封装为分页数据返回给前端。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.TagController.java**）：

接口的映射地址为 /tags/list，请求方法为 GET，代码如下：

```
    public Result list(@RequestParam Map<String, Object> params) {
        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(tagService.getBlogTagPage(pageUtil));
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.TagServiceImpl.java**）：

```
   public PageResult getBlogTagPage(PageQueryUtil pageUtil) {
        List<BlogTag> tags = blogTagMapper.findTagList(pageUtil);
        int total = blogTagMapper.getTotalTags(pageUtil);
        PageResult pageResult = new PageResult(tags, total, pageUtil.getLimit(), pageUtil.getPage());
        return pageResult;
    }
```

- BlogTagMapper.xml （注：完整代码位于 **resources/mapper/BlogTagMapper.xml**）：

```
    <select id="findTagList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog_tag
        where is_deleted=0
        order by tag_id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalTags" parameterType="Map" resultType="int">
    select count(*)  from tb_blog_tag
    where is_deleted=0
      </select>
```

SQL 语句在 BlogTagMapper.xml 文件中， SQL 语句是在自动生成的 SQL 语句中增加了 is_deleted 字段的过滤条件，一般的分页也就是使用 limit 关键字实现，获取响应条数的记录和总数之后再进行数据封装，这个接口就是根据前端传的分页参数进行查询并返回分页数据以供前端页面进行数据渲染。

# 添加标签接口

添加接口负责接收前端的 POST 请求并处理其中的参数，接收的参数为 tagName 字段，tagName 为标签名称。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.TagController.java**）：

接口的映射地址为 /tags/save，请求方法为 POST，代码如下：

```
    @PostMapping("/tags/save")
    @ResponseBody
    public Result save(@RequestParam("tagName") String tagName) {
        if (StringUtils.isEmpty(tagName)) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        if (tagService.saveTag(tagName)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("标签名称重复");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.TagServiceImpl.java**）：

```
    @Override
    public Boolean saveTag(String tagName) {
        BlogTag temp = blogTagMapper.selectByTagName(tagName);
        if (temp == null) {
            BlogTag blogTag = new BlogTag();
            blogTag.setTagName(tagName);
            return blogTagMapper.insertSelective(blogTag) > 0;
        }
        return false;
    }
```

SQL 语句在 BlogTagMapper.xml 文件中，是自动生成的 SQL，这里就不贴了，标签添加的实现逻辑中，首先会对参数进行校验，之后交给业务层代码进行操作，在 saveTag() 方法中，首先会根据名称查询是否已经存在该标签对象，之后才会进行数据封装并进行数据库 insert 操作。

# 删除标签接口

删除接口负责接收前端的标签删除请求，处理前端传输过来的数据后，将这些记录从数据库中删除，这里的“删除”功能并不是真正意义上的删除，而是逻辑删除，我们将接受的参数设置为一个数组，可以同时删除多条记录，只需要在前端将用户选择的记录 id 封装好再传参到后端即可。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.TagController.java**）：

接口的映射地址为 /tags/delete，请求方法为 POST，代码如下：

```
    @PostMapping("/tags/delete")
    @ResponseBody
    public Result delete(@RequestBody Integer[] ids) {
        if (ids.length < 1) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        if (tagService.deleteBatch(ids)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("有关联数据请勿强行删除");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.TagServiceImpl.java**）：

```
    @Override
    public Boolean deleteBatch(Integer[] ids) {
        //已存在关联关系不删除
        List<Long> relations = relationMapper.selectDistinctTagIds(ids);
        if (!CollectionUtils.isEmpty(relations)) {
            return false;
        }
        //删除tag
        return blogTagMapper.deleteBatch(ids) > 0;
    }
```

在业务方法实现中，我们需要判断该标签是否已经与文章表中的数据进行了关联，如果已经存在关联关系，就不进行删除操作，这是其中的一种处理方式，因为在添加文章数据时，也会对应的向数据库中新增标签数据和关系数据（后面的实验中会介绍这些内容），因此在数据删除时需要进行确认以免造成数据混乱，当然也可以使用另外一种处理方法，就是在删除标签记录时，将标签记录以及对应的关系表中所有与此标签有关联的记录删除掉，这样也是可以的，本系统选择的是第一种方式。

- BlogTagMapper.xml （注：完整代码位于 **resources/mapper/BlogTagMapper.xml**）：

```
    <update id="deleteBatch">
        update tb_blog_tag
        set is_deleted=1 where tag_id in
        <foreach item="id" collection="array" open="(" separator="," close=")">
            #{id}
        </foreach>
    </update>
```

- BlogTagRelationMapper.xml（注：完整代码位于 **resources/mapper/BlogTagRelationMapper.xml**）：

```
    <select id="selectDistinctTagIds" resultType="java.lang.Long">
        select
        DISTINCT(tag_id)
        from tb_blog_tag_relation
        where tag_id in
        <foreach item="id" collection="array" open="(" separator="," close=")">
            #{id}
        </foreach>
    </select>
```

接口的请求路径为 /tags/delete，并使用 @RequestBody 将前端传过来的参数封装为 id 数组，参数验证通过后则调用 deleteBatch() 批量删除方法进行数据库操作，否则将向前端返回错误信息。

# 前端页面实现

#### tag.html

在 resources/templates/admin 目录下新建 tag.html，并引入对应的 js 文件和 css 样式文件。

#### 功能按钮及信息编辑框

标签管理模块我们也设计了常用的几个功能：标签信息增加、标签信息删除，因此在页面中添加对应的功能按钮以及触发事件，由于标签信息的字段并不多，因此在按钮区新增了一个标签名称的输入框，代码如下：(**注：完整代码位于 resources/templates/admin/tag.html**)

```
                        <div class="grid-btn">
                            <input type="text" class="form-control col-1" id="tagName" name="tagName"
                                   placeholder="标签名称" required="true">&nbsp;&nbsp;&nbsp;
                            <button class="btn btn-info" onclick="tagAdd()"><i
                                    class="fa fa-plus"></i>&nbsp;新增
                            </button>
                            <button class="btn btn-danger" onclick="deleteTag()"><i
                                    class="fa fa-trash-o"></i>&nbsp;删除
                            </button>
                        </div>
```

分别是添加按钮，对应的触发事件是 tagAdd() 方法，删除按钮，对应的触发事件是 deleteTag() 方法，这些方法我们将在后续的代码实现中给出。

#### 分页信息展示区域

页面中已经引入 JqGrid 的相关静态资源文件，需要在页面中展示分页数据的区域增加如下代码：

```
<table id="jqGrid" class="table table-bordered"></table>
<div id="jqGridPager"></div>
```

#### 页面效果

那么最终的静态页面效果展示如下图所示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379015540/wm)

包括功能按钮、数据列表展示区域以及翻页功能区域，此时只是静态效果展示，并没有与后端进行数据交互，接下来我们将结合 Ajax 和后端接口实现具体的功能。

# 标签管理模块前端功能实现

完成了页面展示的实现，接着完成相关的功能实现。请大家一定自行对照源码完成代码编写。

# 分页功能

在 resources/static/admin/dist/js 目录下新增 tag.js 文件，并添加如下代码：

```
$(function () {
    $("#jqGrid").jqGrid({
        url: '/admin/tags/list',
        datatype: "json",
        colModel: [
            {label: 'id', name: 'tagId', index: 'tagId', width: 50, key: true, hidden: true},
            {label: '标签名称', name: 'tagName', index: 'tagName', width: 240},
            {label: '添加时间', name: 'createTime', index: 'createTime', width: 120}
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

以上代码的主要功能为分页数据展示、字段格式化 jqGrid DOM 宽度的自适应，在页面加载时，调用 JqGrid 的初始化方法，将页面中 id 为 jqGrid 的 DOM 渲染为分页表格，并向后端发送请求，之后按照后端返回的 json 数据填充表格以及表格下方的分页按钮，可以参考第 15 个实验课程中 jqgrid 分页功能整合进行知识的理解，之后可以重启项目验证一下标签信息分页功能是否正常。

# 添加功能

在标签名称输入框中输入完成后可以点击右侧的**添加**按钮，此时会触发 `tagAdd()` 方法进行数据的交互，js 实现代码如下：(**注：完整代码位于 resources/static/admin/dist/js/tag.js**)

```
function tagAdd() {
    var tagName = $("#tagName").val();
    if (!validCN_ENString2_18(tagName)) {
        swal("标签名称不规范", {
            icon: "error",
        });
    } else {
        var url = '/admin/tags/save?tagName=' + tagName;
        $.ajax({
            type: 'POST',//方法类型
            url: url,
            success: function (result) {
                if (result.resultCode == 200) {
                    $("#tagName").val('')
                    swal("保存成功", {
                        icon: "success",
                    });
                    reload();
                }
                else {
                    $("#tagName").val('')
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
}
```

按钮点击后会触发对应的 js 方法，在该方法中首先会对用户输入的数据进行简单的正则验证，之后会封装数据并向对应的后端接口发送 Ajax 请求添加标签数据，之后根据后端返回的结果进行提示。

# 删除功能

删除按钮的点击触发事件为 `deleteTag()`，在 tag.js 文件中新增如下代码：

```
function deleteTag() {
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
                url: "/admin/tags/delete",
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

获取用户在 jqgrid 表格中选择的需要删除的所有记录的 id，之后将参数封装并向后端发送 Ajax 请求，请求地址为 tags/delete，删除功能已经开发完成，同学们可以结合源码以及实际的功能进行学习和理解，接下来我们来进行功能测试。

# 实验楼 web ide 中操作 Spring Boot 项目

我们提供的整个项目的完整代码，请大家下载并参照源码对比学习了解各个功能模块的代码内容。

# 启动 MySQL 并新增 tb_blog_tag 表和 tb_blog_tag_relation 表

详细步骤可以参考实验 15 中的内容，这里就不再浪费篇幅去介绍了。

# 启动项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到已解压的 My-Blog 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 mvn spring-boot:run ，之后就可以等待项目启动。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379052052/wm)

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果，之后会在浏览器中弹出 `https://********.simplelab.cn` 访问页面：`https://********.simplelab.cn/admin/login` 登陆至后台管理首页，之后点击标签管理就可以对相关功能进行测试了，演示过程如下：

- 添加功能：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379064671/wm)

- 删除功能：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379083260/wm)

同学们可以按照文中的思路和过程自行测试，本次实验完成！