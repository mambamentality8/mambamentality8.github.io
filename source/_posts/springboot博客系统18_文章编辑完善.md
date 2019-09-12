# 实验介绍

#### 实验内容

文章的编辑页面以及添加功能已经完成，因为功能比较重要所以用了两个实验来讲解，因为文章实体及相关联的实体是整个系统中最重要的内容，在博客展示系统中也会继续讲解。这个实验我会继续来完善文章模块的相关页面、交互逻辑以及后端功能，主要包括文章修改功能实现、文章管理页面制作和功能实现，这样，整个后台管理系统中的文章模块就开发完成了。

#### 实验知识点

- 文章修改功能(页面跳转、数据回显、修改逻辑代码、Ajax 调用接口逻辑)
- 文章管理接口实现
- 文章管理页面设计及编码
- 文章管理模块测试

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-23.zip
unzip My-Blog-23.zip
cd My-Blog
```

# 文章修改功能

前一个实验中讲解了文章添加的功能实现，包括编辑页面制作和后端接口实现，本实验继续来讲解文章修改功能的整个流程和逻辑实现。

想要修改一篇文章，首先需要获取这篇文章的所有属性，之后再回显到编辑页面中，用户根据需要来修改页面上的内容，点击保存按钮后会想后端发送文章修改请求，后端接口接收到请求后会进行参数验证以及相应的逻辑操作，之后进行数据的入库操作，整个文章修改流程完成。

#### 文章详情

根据流程，首先我们需要获取文章详情，但是文章编辑页面已经有了，所以就没有做成接口形式，而是采用与添加文章时相同的方式，将请求转发到编辑页即可，因为要获取文章详情所以需要根据一个字段来查询，这里就选择 id 作为传参了，在 BlogController 中新增如下代码：(**注：完整代码位于 com.site.blog.my.core.controller.admin.BlogController.java**)

```
    @GetMapping("/blogs/edit/{blogId}")
    public String edit(HttpServletRequest request, @PathVariable("blogId") Long blogId) {
        request.setAttribute("path", "edit");
        Blog blog = blogService.getBlogById(blogId);
        if (blog == null) {
            return "error/error_400";
        }
        request.setAttribute("blog", blog);
        request.setAttribute("categories", categoryService.getAllCategories());
        return "admin/edit";
    }
```

在访问 /blogs/edit/{blogId} 时，会把文章编辑页所需的文章详情内容查询出来并转发到 edit 页面。

#### 页面回显

改造文章编辑页面 edit.html 的代码，通过 Thymeleaf 语法将前一个请求携带的 blog 对象进行读取并显示在编辑页面对应的 DOM 中，修改代码如下：(**注：完整代码位于 resources/templates/admin/edit.html**)

```
<form id="blogForm" onsubmit="return false;">
    <div class="form-group" style="display:flex;">
        <input type="hidden" id="blogId" name="blogId"
               th:value="${blog!=null and blog.blogId!=null }?${blog.blogId}: 0">
        <input type="text" class="form-control col-sm-6" id="blogName" name="blogName"
               placeholder="*请输入文章标题(必填)"
               th:value="${blog!=null and blog.blogTitle!=null }?${blog.blogTitle}: ''"
               required="true">
        &nbsp;&nbsp;
        <input type="text" class="form-control" id="blogTags" name="blogTags"
               placeholder="请输入文章标签"
               th:value="${blog!=null and blog.blogTags!=null }?${blog.blogTags}: ''"
               style="width: 100%;">
    </div>
    <div class="form-group" style="display:flex;">
        <input type="text" class="form-control col-sm-6" id="blogSubUrl"
               name="blogSubUrl"
               th:value="${blog!=null and blog.blogSubUrl!=null }?${blog.blogSubUrl}: ''"
               placeholder="请输入自定义路径,如:springboot-mybatis,默认为id"> &nbsp;&nbsp;
        <select class="form-control select2" style="width: 100%;" id="blogCategoryId"
                data-placeholder="请选择分类...">
            <th:block th:if="${null == categories}">
                <option value="0" selected="selected">默认分类</option>
            </th:block>
            <th:block th:unless="${null == categories}">
                <th:block th:each="c : ${categories}">
                    <option th:value="${c.categoryId}" th:text="${c.categoryName}"
                            th:selected="${null !=blog and null !=blog.blogCategoryId and blog.blogCategoryId==c.categoryId} ?true:false">
                        >
                    </option>
                </th:block>
            </th:block>
        </select>
    </div>
    <div class="form-group" id="blog-editormd">
        <textarea style="display:none;"
                  th:utext="${blog!=null and blog.blogContent !=null}?${blog.blogContent}: ''"></textarea>
    </div>
    <div class="form-group">
        <div class="col-sm-4">
            <th:block th:if="${null == blog}">
                <img id="blogCoverImage" src="/admin/dist/img/img-upload.png"
                     style="height: 64px;width: 64px;">
            </th:block>
            <th:block th:unless="${null == blog}">
                <img id="blogCoverImage" th:src="${blog.blogCoverImage}"
                     style="width:160px ;height: 120px;display:block;">
            </th:block>
        </div>
    </div>
    <br>
    <div class="form-group">
        <div class="col-sm-4">
            <button class="btn btn-info" style="margin-bottom: 5px;" id="uploadCoverImage">
                <i class="fa fa-picture-o"></i>&nbsp;上传封面
            </button>
            <button class="btn btn-secondary"
                    style="margin-bottom: 5px;"
                    id="randomCoverImage"><i
                    class="fa fa-random"></i>&nbsp;随机封面
            </button>
        </div>
    </div>
    <div class="form-group">
        <label class="control-label">文章状态:&nbsp;</label>
        <input name="blogStatus" type="radio" id="publish"
               checked=true
               th:checked="${null==blog||(null !=blog and null !=blog.blogStatus and blog.blogStatus==1)} ?true:false"
               value="1"/>&nbsp;发布&nbsp;
        <input name="blogStatus" type="radio" id="draft" value="0"
               th:checked="${null !=blog and null !=blog.blogStatus and blog.blogStatus==0} ?true:false"/>&nbsp;草稿&nbsp;&nbsp;&nbsp;
        <label class="control-label">是否允许评论:&nbsp;</label>
        <input name="enableComment" type="radio" id="enableCommentTrue" checked=true
               th:checked="${null==blog||(null !=blog and null !=blog.enableComment and blog.enableComment==0)} ?true:false"
               value="0"/>&nbsp;是&nbsp;
        <input name="enableComment" type="radio" id="enableCommentFalse" value="1"
               th:checked="${null !=blog and null !=blog.enableComment and blog.enableComment==1} ?true:false"/>&nbsp;否&nbsp;
    </div>
    <div class="form-group">
        <!-- 按钮 -->
        &nbsp;<button class="btn btn-info float-right" style="margin-left: 5px;"
                      id="confirmButton">保存文章
    </button>&nbsp;
        &nbsp;<button class="btn btn-secondary float-right" style="margin-left: 5px;"
                      id="cancelButton">返回文章列表
    </button>&nbsp;
    </div>
</form>
```

只是在原来编辑 DOM 的基础上加上 Thymeleaf 读取的语法，并不是特别难的知识点，这样改造之后就完成了编辑功能的前两步，获取详情并回显到编辑页面中。

#### 文章修改接口实现

前一个实验中我们讲解了文章添加接口的实现，而大部分功能模块的修改接口，都与添加接口类似，唯一的不同点就是修改接口需要知道修改的是哪一条，因此可以模仿添加接口来实现文章修改接口，修改接口负责接收前端的 POST 请求并处理其中的参数，接收的参数为用户在博客编辑页面输入的所有字段内容以及文章的主键 id，字段名称与对应的含义如下：

1. "**blogId**": 文章主键
2. "**blogTitle**": 文章标题
3. "**blogSubUrl**": 自定义路径
4. "**blogCategoryId**": 分类 id (下拉框中选择)
5. "**blogTags**": 标签字段(以逗号分隔)
6. "**blogContent**": 文章内容(编辑器中的 md 文档)
7. "**blogCoverImage**": 封面图(上传图片或者随机图片的路径)
8. "**blogStatus**": 文章状态
9. "**enableComment**": 评论开关

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.BlogController.java**）

在 BlogController 中新增 update() 方法，接口的映射地址为 /blogs/update，请求方法为 POST，代码如下：

```
@PostMapping("/blogs/update")
    @ResponseBody
    public Result update(@RequestParam("blogId") Long blogId,
                         @RequestParam("blogTitle") String blogTitle,
                         @RequestParam(name = "blogSubUrl", required = false) String blogSubUrl,
                         @RequestParam("blogCategoryId") Integer blogCategoryId,
                         @RequestParam("blogTags") String blogTags,
                         @RequestParam("blogContent") String blogContent,
                         @RequestParam("blogCoverImage") String blogCoverImage,
                         @RequestParam("blogStatus") Byte blogStatus,
                         @RequestParam("enableComment") Byte enableComment) {
        if (StringUtils.isEmpty(blogTitle)) {
            return ResultGenerator.genFailResult("请输入文章标题");
        }
        if (blogTitle.trim().length() > 150) {
            return ResultGenerator.genFailResult("标题过长");
        }
        if (StringUtils.isEmpty(blogTags)) {
            return ResultGenerator.genFailResult("请输入文章标签");
        }
        if (blogTags.trim().length() > 150) {
            return ResultGenerator.genFailResult("标签过长");
        }
        if (blogSubUrl.trim().length() > 150) {
            return ResultGenerator.genFailResult("路径过长");
        }
        if (StringUtils.isEmpty(blogContent)) {
            return ResultGenerator.genFailResult("请输入文章内容");
        }
        if (blogTags.trim().length() > 100000) {
            return ResultGenerator.genFailResult("文章内容过长");
        }
        if (StringUtils.isEmpty(blogCoverImage)) {
            return ResultGenerator.genFailResult("封面图不能为空");
        }
        Blog blog = new Blog();
        blog.setBlogId(blogId);
        blog.setBlogTitle(blogTitle);
        blog.setBlogSubUrl(blogSubUrl);
        blog.setBlogCategoryId(blogCategoryId);
        blog.setBlogTags(blogTags);
        blog.setBlogContent(blogContent);
        blog.setBlogCoverImage(blogCoverImage);
        blog.setBlogStatus(blogStatus);
        blog.setEnableComment(enableComment);
        String updateBlogResult = blogService.updateBlog(blog);
        if ("success".equals(updateBlogResult)) {
            return ResultGenerator.genSuccessResult("修改成功");
        } else {
            return ResultGenerator.genFailResult(updateBlogResult);
        }
    }
```

首先会对参数进行校验，之后交给业务层代码进行操作，与添加接口不同的是传参，多了主键 id，我们需要知道要修改的哪一条数据。

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）

在 service 包中新建 BlogService 并定义接口方法 `updateBlog()`，下面为具体的实现方法代码：

```
@Override
    @Transactional
    public String updateBlog(Blog blog) {
        Blog blogForUpdate = blogMapper.selectByPrimaryKey(blog.getBlogId());
        if (blogForUpdate == null) {
            return "数据不存在";
        }
        blogForUpdate.setBlogTitle(blog.getBlogTitle());
        blogForUpdate.setBlogSubUrl(blog.getBlogSubUrl());
        blogForUpdate.setBlogContent(blog.getBlogContent());
        blogForUpdate.setBlogCoverImage(blog.getBlogCoverImage());
        blogForUpdate.setBlogStatus(blog.getBlogStatus());
        blogForUpdate.setEnableComment(blog.getEnableComment());
        BlogCategory blogCategory = categoryMapper.selectByPrimaryKey(blog.getBlogCategoryId());
        if (blogCategory == null) {
            blogForUpdate.setBlogCategoryId(0);
            blogForUpdate.setBlogCategoryName("默认分类");
        } else {
            //设置博客分类名称
            blogForUpdate.setBlogCategoryName(blogCategory.getCategoryName());
            blogForUpdate.setBlogCategoryId(blogCategory.getCategoryId());
            //分类的排序值加1
            blogCategory.setCategoryRank(blogCategory.getCategoryRank() + 1);
        }
        //处理标签数据
        String[] tags = blog.getBlogTags().split(",");
        if (tags.length > 6) {
            return "标签数量限制为6";
        }
        blogForUpdate.setBlogTags(blog.getBlogTags());
        //新增的tag对象
        List<BlogTag> tagListForInsert = new ArrayList<>();
        //所有的tag对象，用于建立关系数据
        List<BlogTag> allTagsList = new ArrayList<>();
        for (int i = 0; i < tags.length; i++) {
            BlogTag tag = tagMapper.selectByTagName(tags[i]);
            if (tag == null) {
                //不存在就新增
                BlogTag tempTag = new BlogTag();
                tempTag.setTagName(tags[i]);
                tagListForInsert.add(tempTag);
            } else {
                allTagsList.add(tag);
            }
        }
        //新增标签数据不为空->新增标签数据
        if (!CollectionUtils.isEmpty(tagListForInsert)) {
            tagMapper.batchInsertBlogTag(tagListForInsert);
        }
        List<BlogTagRelation> blogTagRelations = new ArrayList<>();
        //新增关系数据
        allTagsList.addAll(tagListForInsert);
        for (BlogTag tag : allTagsList) {
            BlogTagRelation blogTagRelation = new BlogTagRelation();
            blogTagRelation.setBlogId(blog.getBlogId());
            blogTagRelation.setTagId(tag.getTagId());
            blogTagRelations.add(blogTagRelation);
        }
        //修改blog信息->修改分类排序值->删除原关系数据->保存新的关系数据
        categoryMapper.updateByPrimaryKeySelective(blogCategory);
        //删除原关系数据
        blogTagRelationMapper.deleteByBlogId(blog.getBlogId());
        blogTagRelationMapper.batchInsert(blogTagRelations);
        if (blogMapper.updateByPrimaryKeySelective(blogForUpdate) > 0) {
            return "success";
        }
        return "修改失败";
    }
```

这个方法可以结合文章添加的业务层方法来学习，这里仅仅讲一下不同点，首先，`updateBlog()` 方法会判断是否存在当前想要修改的记录，之后的标签及标签关系处理逻辑与 `saveBlog()` 方法一样，不同点是关系数据的保存，`saveBlog()` 方法是直接保存关系数据，因为是全新的关系数据，而 `updateBlog()` 方法的处理则需要修改，因为在修改前就可能已经存在关系数据了，所以需要先把关系数据删掉再保存新的关系数据。

- 关键 SQL

根据文章 id 删除原来的关系数据 （注：完整代码位于 **resources/mapper/BlogTagRelationMapper.xml**）

```
    <delete id="deleteByBlogId" parameterType="java.lang.Long">
        delete from tb_blog_tag_relation
        where blog_id = #{blogId,jdbcType=BIGINT}
    </delete>
```

#### Ajax 调用修改接口

对文章数据进行修改之后可以点击信息编辑框下方的**保存文章**按钮，此时会调用后端接口并进行数据的交互，js 实现代码如下：(**注：完整代码位于 resources/static/admin/dist/js/edit.js**)

```
$('#confirmButton').click(function () {
    var blogId = $('#blogId').val();
    var blogTitle = $('#blogName').val();
    var blogSubUrl = $('#blogSubUrl').val();
    var blogCategoryId = $('#blogCategoryId').val();
    var blogTags = $('#blogTags').val();
    var blogContent = blogEditor.getMarkdown();
    var blogCoverImage = $('#blogCoverImage')[0].src;
    var blogStatus = $("input[name='blogStatus']:checked").val();
    var enableComment = $("input[name='enableComment']:checked").val();
    if (isNull(blogTitle)) {
        swal("请输入文章标题", {
            icon: "error",
        });
        return;
    }
    if (!validLength(blogTitle, 150)) {
        swal("标题过长", {
            icon: "error",
        });
        return;
    }
    if (!validLength(blogSubUrl, 150)) {
        swal("路径过长", {
            icon: "error",
        });
        return;
    }
    if (isNull(blogCategoryId)) {
        swal("请选择文章分类", {
            icon: "error",
        });
        return;
    }
    if (isNull(blogTags)) {
        swal("请输入文章标签", {
            icon: "error",
        });
        return;
    }
    if (!validLength(blogTags, 150)) {
        swal("标签过长", {
            icon: "error",
        });
        return;
    }
    if (isNull(blogContent)) {
        swal("请输入文章内容", {
            icon: "error",
        });
        return;
    }
    if (!validLength(blogTags, 100000)) {
        swal("文章内容过长", {
            icon: "error",
        });
        return;
    }
    if (isNull(blogCoverImage) || blogCoverImage.indexOf('img-upload') != -1) {
        swal("封面图片不能为空", {
            icon: "error",
        });
        return;
    }
    var url = '/admin/blogs/save';
    var swlMessage = '保存成功';
    var data = {
        "blogTitle": blogTitle, "blogSubUrl": blogSubUrl, "blogCategoryId": blogCategoryId,
        "blogTags": blogTags, "blogContent": blogContent, "blogCoverImage": blogCoverImage, "blogStatus": blogStatus,
        "enableComment": enableComment
    };
    //blogId大于0则为修改操作
    if (blogId > 0) {
        url = '/admin/blogs/update';
        swlMessage = '修改成功';
        data = {
            "blogId": blogId,
            "blogTitle": blogTitle,
            "blogSubUrl": blogSubUrl,
            "blogCategoryId": blogCategoryId,
            "blogTags": blogTags,
            "blogContent": blogContent,
            "blogCoverImage": blogCoverImage,
            "blogStatus": blogStatus,
            "enableComment": enableComment
        };
    }
    console.log(data);
    $.ajax({
        type: 'POST',//方法类型
        url: url,
        data: data,
        success: function (result) {
            if (result.resultCode == 200) {
                swal(swlMessage, {
                    icon: "success"
                });
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

这个方法就是直接改造前一个实验中的方法，在保存按钮的点击事件处理函数中，首先判断 blogId 是否大于 0，如果大于 0 则证明这是一个修改请求，之后封装数据并向后端发送 Ajax 请求修改文章。

# 文章管理页面制作

#### 导航栏

首先在左侧导航栏中新增编辑页的导航按钮，在 sidebar.html 文件中新增如下代码：(**注：完整代码位于 resources/templates/admin/sidebar.html**)

```
                <li class="nav-item">
                    <a th:href="@{/admin/blogs}" th:class="${path}=='blogs'?'nav-link active':'nav-link'">
                        <i class="fa fa-list-alt nav-icon" aria-hidden="true"></i>
                        <p>
                            博客管理
                        </p>
                    </a>
                </li>
```

点击后的跳转路径为 /admin/blogs，之后我们新建 Controller 来处理该路径并跳转到对应的页面。

#### Controller 处理跳转

首先在 controller/admin 包下新建 BlogController.java，之后新增如下代码：

```
    @GetMapping("/blogs")
    public String list(HttpServletRequest request) {
        request.setAttribute("path", "blogs");
        return "admin/blog";
    }
```

该方法用于处理 /admin/blogs 请求，并设置 path 字段，之后跳转到 admin 目录下的 blog.html 中。

#### blog.html 页面制作

接下来就是博客管理页面的模板文件制作了，在 resources/templates/admin 目录下新建 blog.html，并引入对应的 js 文件和 css 样式文件，代码如下：

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
                        <h3 class="card-title">博客管理</h3>
                    </div> <!-- /.card-body -->
                    <div class="card-body">
                    </div><!-- /.card-body -->
                </div>
            </div><!-- /.container-fluid -->
        </div>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->
    <!-- 引入页脚footer-fragment -->
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
<!-- jqgrid -->
<script th:src="@{/admin/plugins/jqgrid-5.3.0/jquery.jqGrid.min.js}"></script>
<script th:src="@{/admin/plugins/jqgrid-5.3.0/grid.locale-cn.js}"></script>
<!-- sweetalert -->
<script th:src="@{/admin/plugins/sweetalert/sweetalert.min.js}"></script>
<script th:src="@{/admin/dist/js/public.js}"></script>
</body>
</html>
```

至此，跳转逻辑处理完毕，演示效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379945783/wm)

# 博客管理模块接口设计及实现

因为文章添加和文章修改功能都已经实现，在管理模块中也仅仅只需要列表功能和删除功能了，因此只介绍分页接口和删除接口，另外两个接口在前文中已经介绍了。

# 文章列表分页接口

列表接口负责接收前端传来的分页参数，如 page 、limit 等参数，之后将数据总数和对应页面的数据列表查询出来并封装为分页数据返回给前端。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.BlogController.java**）：

接口的映射地址为 /blogs/list，请求方法为 GET，代码如下：

```
    @GetMapping("/blogs/list")
    @ResponseBody
    public Result list(@RequestParam Map<String, Object> params) {
        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(blogService.getBlogsPage(pageUtil));
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）：

```
    public PageResult getBlogsPage(PageQueryUtil pageUtil) {
        List<Blog> blogList = blogMapper.findBlogList(pageUtil);
        int total = blogMapper.getTotalBlogs(pageUtil);
        PageResult pageResult = new PageResult(blogList, total, pageUtil.getLimit(), pageUtil.getPage());
        return pageResult;
    }
```

- BlogCategoryMapper.xml （注：完整代码位于 **resources/mapper/BlogMapper.xml**）：

```
    <select id="findBlogList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog
        where is_deleted=0
        order by blog_id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalBlogs" parameterType="Map" resultType="int">
        select count(*) from tb_blog
        where is_deleted=0
    </select>
```

SQL 语句在 BlogMapper.xml 文件中，一般的分页也就是使用 limit 关键字实现，获取响应条数的记录和总数之后再进行数据封装，这个接口就是根据前端传的分页参数进行查询并返回分页数据以供前端页面进行数据渲染。

# 删除接口

删除接口负责接收前端的文章删除请求，处理前端传输过来的数据后，将这些记录从数据库中删除，这里的“删除”功能并不是真正意义上的删除，而是逻辑删除，我们将接受的参数设置为一个数组，可以同时删除多条记录，只需要在前端将用户选择的记录 id 封装好再传参到后端即可。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.BlogController.java**）：

接口的映射地址为 /blogs/delete，请求方法为 POST，代码如下：

```
    @PostMapping("/blogs/delete")
    @ResponseBody
    public Result delete(@RequestBody Integer[] ids) {
        if (ids.length < 1) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        if (blogService.deleteBatch(ids)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("删除失败");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）：

```
    public Boolean deleteBatch(Integer[] ids) {
        if (ids.length < 1) {
            return false;
        }
        return blogMapper.deleteBatch(ids) > 0;
    }
```

- BlogMapper.xml （注：完整代码位于 **resources/mapper/BlogMapper.xml**）：

```
    <update id="deleteBatch">
        update tb_blog
        set is_deleted=1 where blog_id in
        <foreach item="id" collection="array" open="(" separator="," close=")">
            #{id}
        </foreach>
    </update>
```

接口的请求路径为 /blogs/delete，并使用 `@RequestBody` 将前端传过来的参数封装为 id 数组，参数验证通过后则调用 `deleteBatch()` 批量删除方法进行数据库操作，否则将向前端返回错误信息。

# 前端页面实现

#### 功能按钮

管理页面中我们设计了常用的几个功能按钮：文章添加按钮、文章修改按钮、文章删除按钮，因此在页面中添加对应的功能按钮以及触发事件，代码如下：(**注：完整代码位于 resources/templates/admin/category.html**)

```
    <div class="grid-btn">
        <button class="btn btn-success" onclick="addBlog()"><i
                class="fa fa-plus"></i>&nbsp;新增
        </button>
        <button class="btn btn-info" onclick="editBlog()"><i
                class="fa fa-edit"></i>&nbsp;修改
        </button>
        <button class="btn btn-danger" onclick="deleteBlog()"><i
                class="fa fa-trash-o"></i>&nbsp;删除
        </button>
    </div>
```

分别是添加按钮对应的触发事件是 `addBlog()` 方法，修改按钮对应的触发事件是 `editBlog()` 方法，删除按钮对应的触发事件是 deleteBlog() 方法，这些方法我们将在后续的代码实现中给出。

#### 分页信息展示区域

页面中已经引入 JqGrid 的相关静态资源文件，需要在页面中展示分页数据的区域增加如下代码：(**注：完整代码位于 resources/templates/admin/category.html**)

```
    <!-- JqGrid必要DOM,用于创建表格展示列表数据 -->
    <table id="jqGrid" class="table table-bordered"></table>
    <!-- JqGrid必要DOM,分页信息区域 -->
    <div id="jqGridPager"></div>
```

# 文章管理模块前端功能实现

完成了页面展示的实现，接着完成相关的功能实现。请大家一定自行对照源码完成代码编写。

# 分页功能

在 resources/static/admin/dist/js 目录下新增 blog.js 文件，并添加如下代码：

```
$(function () {
    $("#jqGrid").jqGrid({
        url: '/admin/blogs/list',
        datatype: "json",
        colModel: [
            {label: 'id', name: 'blogId', index: 'blogId', width: 50, key: true, hidden: true},
            {label: '标题', name: 'blogTitle', index: 'blogTitle', width: 140},
            {label: '预览图', name: 'blogCoverImage', index: 'blogCoverImage', width: 120, formatter: coverImageFormatter},
            {label: '浏览量', name: 'blogViews', index: 'blogViews', width: 60},
            {label: '状态', name: 'blogStatus', index: 'blogStatus', width: 60, formatter: statusFormatter},
            {label: '博客分类', name: 'blogCategoryName', index: 'blogCategoryName', width: 60},
            {label: '添加时间', name: 'createTime', index: 'createTime', width: 90}
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

    function coverImageFormatter(cellvalue) {
        return "<img src='" + cellvalue + "' height=\"120\" width=\"160\" alt='coverImage'/>";
    }

    function statusFormatter(cellvalue) {
        if (cellvalue == 0) {
            return "<button type=\"button\" class=\"btn btn-block btn-secondary btn-sm\" style=\"width: 50%;\">草稿</button>";
        }
        else if (cellvalue == 1) {
            return "<button type=\"button\" class=\"btn btn-block btn-success btn-sm\" style=\"width: 50%;\">发布</button>";
        }
    }

});
```

以上代码的主要功能为分页数据展示、字段格式化 jqGrid DOM 宽度的自适应，在页面加载时，调用 JqGrid 的初始化方法，将页面中 id 为 jqGrid 的 DOM 渲染为分页表格，并向后端发送请求，之后按照后端返回的 json 数据填充表格以及表格下方的分页按钮，可以参考第 15 个实验课程中 jqgrid 分页功能整合进行知识的理解，之后可以重启项目验证一下分页功能是否正常。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379972215/wm)

# 按钮事件

添加和修改两个按钮分别绑定了触发事件，我们需要在 blog.js 文件中新增 addBlog() 方法和 editBlog() 方法，两个方法中的实现均为跳转至文章编辑页面，触发事件代码如下：(**注：完整代码位于 resources/static/admin/dist/js/blog.js**)

```
function addBlog() {
    window.location.href = "/admin/blogs/edit";
}

function editBlog() {
    var id = getSelectedRow();
    if (id == null) {
        return;
    }
    window.location.href = "/admin/blogs/edit/" + id;
}
```

点击添加按钮时是直接跳转到文章编辑页，点击修改时首先要获取当前选择的需要修改的文章 id，之后跳转至文章编辑页，添加和修改操作则是在编辑页面完成，这里就只是跳转。

# 删除功能

删除按钮的点击触发事件为 `deleteBlog()`，在 blog.js 文件中新增如下代码：(**注：完整代码位于 resources/static/admin/dist/js/blog.js**)

```
function deleteBlog() {
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
                    url: "/admin/blogs/delete",
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

获取用户在 jqgrid 表格中选择的需要删除的所有记录的 id，之后将参数封装并向后端发送 Ajax 请求，请求地址为 blogs/delete，删除功能已经开发完成，同学们可以结合源码以及实际的功能进行学习和理解，接下来我们来进行功能测试。

# 功能验证

我们提供了本实验所需的完整代码，请大家下载并参照源码对比学习了解各个功能模块的代码内容。

# 启动 MySQL

**如果 MySQL 数据库服务没有启动的话需要进行这一步操作。**

# 启动项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到已解压的 My-Blog 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 `mvn spring-boot:run`，之后就可以等待项目启动。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379989582/wm)

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果，之后会在浏览器中弹出 `https://********.simplelab.cn` 访问页面：`https://1423b0da00a8.simplelab.cn/admin/login` 并登陆至后台管理首页，之后点击博客管理就可以对相关功能进行测试了。

- 文章列表

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380001494/wm)

- 文章修改

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380011986/wm)

- 文章删除

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380033261/wm)

#### 验证

与前一个实验的验证步骤一样，因为都是关于文章的，所以主要是两个方面：

- **数据库中的记录是否正确**
- **如果有进行图片上传的话 upload 目录下是否有正确的文件**

同学们可以按照文中的思路和过程自行测试，本次实验完成！

# 总结

后台管理系统中博客文章模块到这里就暂时告一段落了，这个模块的讲解总共用了三个实验，因为这个模块确实是整个系统中最重要的部分，希望同学们可以按照我给的思路以及源码把这部分知识点全部掌握，接下来是其他模块的开发。