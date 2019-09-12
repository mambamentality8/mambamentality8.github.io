# 实验介绍

#### 实验内容

首页所有的功能基本都开发完成，首屏页面上大部分显示区域都实现了数据交互，当然，细心的同学也会发现我们还有一处搜索框没有做任何的更改也没有做任何的数据交互，搜索框即是首屏页面实现中漏掉的一个功能，也就是我们本节实验需要实现的**搜索功能**，这一节会实现博客页面所有的搜索功能，包括搜索框搜索(关键字搜索)、按照分类搜索、按照标签搜索。

#### 实验知识点

- 关键字搜索功能
- 搜索页面制作
- 分类搜索功能
- 标签搜索功能

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-27.zip
unzip My-Blog-27.zip
cd My-Blog
```

# 关键字搜索功能实现

#### 页面设计

接下来就是我们本次实验的第一个部分--**关键字搜索功能实现**，首先来看一下最终的搜索页展现效果来确认该页面的布局设计，如下图所示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380814885/wm)

该页面与首页极度相似，也包括顶部导航栏、文章列表区域、底部页脚区域，不同的是缺少了侧边工具栏区域，顶部区域和底部区域是公共区域，这里就不再赘述，重点关注一下图中标注的三个地方,如上图所示，分别标注了三个区域：

1. **搜索页副标题区域**：这个区域处于整个搜索页面功能区的顶部，用于显示搜索信息,因为后续根据分类搜索和根据标签搜索功能也会用到该页面，在显示搜索信息的同时也对搜索功能进行区分；
2. **文章列表区域**：用于展示文章列表，显示文章的概览信息，与首页不同的是该页面没有侧边工具栏区域所以文章列表区域会更大一些；
3. **分页导航区域**：放置分页按钮，用于分页跳转功能。

#### 数据格式定义

如下图所示即为博客列表中需要渲染的内容，首先博客列表肯定是一个 List 对象，但是因为有分页功能，所以还需要返回分页字段，因此最终接收到的结果返回格式为 PageResult 对象，而列表中的单项对象中的字段则需要通过下图中的内容进行确认。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380830618/wm)

通过图片我们可以看到博客标题字段、预览图字段、分类名称字段、分类图片字段，当然这里通常会设计成可跳转的形式，即点击标题或者预览图后会跳转到对应的博客详情页面中，点击分类名称或者分类图片也会跳转到对应的博客分类页面，因此还需要一个博客实体的 id 字段和分类实体的 id 字段，因此返回数据的格式就得出来了，与首页的数据模型一样也是使用 BlogListVO 对象。

#### 发起搜索请求

接下来就是讲解一下整个搜索功能的第一步--**发起搜索请求**，该操作通过提交搜索框中的内容来实现。

- 首先需要对搜索框所在的 form 表单进行代码修改，这部分内容在 header.html，修改如下：(**注：完整代码位于 resources/templates/blog/header.html**)

```
    <form method="get" onsubmit="return false;" accept-charset="utf-8">
        <input class="searchfield" id="searchbox" type="text" placeholder="  搜索">
        <button class="searchbutton" id="searchbutton" onclick="search()">
            <i class="fa fa-search"></i>
        </button>
    </form>
```

修改 form 表单的 `onsubmit` 事件，同时增加搜索按钮的 `onclick()` 事件，在用户点击搜索按钮后执行 `search()` 方法。

- 在 resources/static/blog/js 目录下新增 search.js，新增如下代码：

```
$(function () {
    $('#searchbox').keypress(function (e) {
        var key = e.which; //e.which是按键的值
        if (key == 13) {
            var q = $(this).val();
            if (q && q != '') {
                window.location.href = '/search/' + q;
            }
        }
    });
});

function search() {
    var q = $('#searchbox').val();
    if (q && q != '') {
        window.location.href = '/search/' + q;
    }
}
```

该 js 文件中定义了 `search()` 方法的实现，在用户点击搜索按钮后会将用户输入的字段取出来并放入搜索请求的路径中进行请求，同时也定义了输入框的 `keypress()` 事件，当用户在输入框中输入需要搜索的字段后敲下 Enter 回车键，也可以发起搜索请求。

1. 最后修改 blog/index.html ，增加 search.js 的引用代码：

```
<script th:src="@{/blog/js/search.js}"></script>
```

#### 数据查询实现

接下来是数据查询的功能实现，上述博客列表中的字段可以通过直接查询 tb_blog 文章表和 tb_blog_category 表来获取，同时需要注意分页功能实现，传参时需要传入关键字和页码，实现逻辑如下。

首先，定义 service 方法，业务层代码如下（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）：

```
    /**
     * 根据搜索关键字获取首页文章列表
     *
     * @param page
     * @return
     */
    public PageResult getBlogsPageBySearch(String keyword, int page) {
            if (page > 0 && PatternUtil.validKeyword(keyword)) {
                Map param = new HashMap();
                param.put("page", page);
                param.put("limit", 9);
                param.put("keyword", keyword);
                param.put("blogStatus", 1);//过滤发布状态下的数据
                PageQueryUtil pageUtil = new PageQueryUtil(param);
                List<Blog> blogList = blogMapper.findBlogList(pageUtil);
                List<BlogListVO> blogListVOS = getBlogListVOsByBlogs(blogList);
                int total = blogMapper.getTotalBlogs(pageUtil);
                PageResult pageResult = new PageResult(blogListVOS, total, pageUtil.getLimit(), pageUtil.getPage());
                return pageResult;
            }
            return null;
        }

    /**
     * 数据填充
     */
    private List<BlogListVO> getBlogListVOsByBlogs(List<Blog> blogList) {
        List<BlogListVO> blogListVOS = new ArrayList<>();
        if (!CollectionUtils.isEmpty(blogList)) {
            List<Integer> categoryIds = blogList.stream().map(Blog::getBlogCategoryId).collect(Collectors.toList());
            Map<Integer, String> blogCategoryMap = new HashMap<>();
            if (!CollectionUtils.isEmpty(categoryIds)) {
                List<BlogCategory> blogCategories = categoryMapper.selectByCategoryIds(categoryIds);
                if (!CollectionUtils.isEmpty(blogCategories)) {
                    blogCategoryMap = blogCategories.stream().collect(Collectors.toMap(BlogCategory::getCategoryId, BlogCategory::getCategoryIcon, (key1, key2) -> key2));
                }
            }
            for (Blog blog : blogList) {
                BlogListVO blogListVO = new BlogListVO();
                BeanUtils.copyProperties(blog, blogListVO);
                if (blogCategoryMap.containsKey(blog.getBlogCategoryId())) {
                    blogListVO.setBlogCategoryIcon(blogCategoryMap.get(blog.getBlogCategoryId()));
                } else {
                    blogListVO.setBlogCategoryId(0);
                    blogListVO.setBlogCategoryName("默认分类");
                    blogListVO.setBlogCategoryIcon("/admin/dist/img/category/1.png");
                }
                blogListVOS.add(blogListVO);
            }
        }
        return blogListVOS;
    }
```

我们定义了 `getBlogsPageBySearch()` 方法并传入 keyword 和 page 参数，keyword 用来过滤想要的文章列表，page 用于确定查询第几页的数据，之后通过 SQL 查询出对应的分页数据，再之后是填充数据，某些字段是 tb_blog 表中没有的，所以再去分类表中查询并设置到 BlogListVO 对象中，最终返回的数据是 PageResult 对象。

具体的 SQL 语句如下（注：完整代码位于 **resources/mapper/BlogMapper.xml**）：

```
    <select id="findBlogList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog
        where is_deleted=0
        <if test="keyword!=null">
            AND (blog_title like CONCAT('%','${keyword}','%' ) or blog_category_name like CONCAT('%','${keyword}','%' ))
        </if>
        <if test="blogStatus!=null">
            AND blog_status = #{blogStatus}
        </if>
        order by blog_id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalBlogs" parameterType="Map" resultType="int">
        select count(*) from tb_blog
        where is_deleted=0
        <if test="keyword!=null">
            AND (blog_title like CONCAT('%','${keyword}','%' ) or blog_category_name like CONCAT('%','${keyword}','%' ))
        </if>
        <if test="blogStatus!=null">
            AND blog_status = #{blogStatus}
        </if>
    </select>
```

在原来查询博客列表 SQL 的基础上增加了对于 blog_title 字段和 blog_category_name 的过滤，使用 LIKE 语法对博客记录进行检索。

#### 数据渲染

想要将数据通过 Thymeleaf 语法渲染到前端页面上，首先需要将数据获取并转发到对应的模板页面中，需要在 Controller 方法中将查询到的数据放入 request 域中，新增 search() 方法，代码如下：(**注：完整代码位于 com.site.blog.my.core.controller.blog.MyBlogController**)

```
    /**
     * 搜索列表页
     *
     * @return
     */
    @GetMapping({"/search/{keyword}"})
    public String search(HttpServletRequest request, @PathVariable("keyword") String keyword) {
        return search(request, keyword, 1);
    }

    /**
     * 搜索列表页
     *
     * @return
     */
    @GetMapping({"/search/{keyword}/{page}"})
    public String search(HttpServletRequest request, @PathVariable("keyword") String keyword, @PathVariable("page") Integer page) {
        PageResult blogPageResult = blogService.getBlogsPageBySearch(keyword, page);
        request.setAttribute("blogPageResult", blogPageResult);
        request.setAttribute("pageName", "搜索");
        request.setAttribute("pageUrl", "search");
        request.setAttribute("keyword", keyword);
        return "blog/list";
    }
```

路径映射为 /search/{keyword}/{page}，page 参数不传的话默认为第 1 页，根据页码和关键字查询出对应的分页数据 blogPageResult 并放入到 request 对象中，之后跳转到 list 模板页面进行数据渲染，需要注意的是 pageName 字段、 pageUrl 字段和 keyword 字段，这些字段主要是为了搜索页副标题区域的显示和翻页链接的拼接。

新增搜索页 list.html ，模板代码如下：(**注：完整代码位于 resources/templates/blog/list.html**)

```
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="blog/header::head-fragment"></head>
<body>
<header th:replace="blog/header::header-fragment"></header>
<div class="widewrapper main">
    <div class="container">
        <div class="row">
            <div class="col-md-12 blog-main">
                <th:block th:if="${null != blogPageResult}">
                    <th:block th:each="blog,iterStat : ${blogPageResult.list}">
                        <div class="col-md-4 col-sm-4 blog-main-card">
                            <article class="blog-summary">
                                <header>
                                    <a th:href="@{'/blog/' + ${blog.blogId}}">
                                        <img th:src="@{${blog.blogCoverImage}}" alt="">
                                        <h3>
                                            <th:block th:text="${blog.blogTitle}"></th:block>
                                        </h3>
                                    </a>
                                    <div class="blog-category">
                                        <a th:href="@{'/category/' + ${blog.blogCategoryName}}">
                                            <div class="blog-category-icon">
                                                <img th:src="@{${blog.blogCategoryIcon}}" alt="">
                                            </div>
                                            <div class="blog-category" th:utext="${blog.blogCategoryName}">
                                            </div>
                                        </a>
                                    </div>
                                </header>
                            </article>
                        </div>
                        <th:block th:if="${iterStat.last and iterStat.count%3==1}">
                            <div class="col-md-4 col-sm-4 blog-main-card"></div>
                            <div class="col-md-4 col-sm-4 blog-main-card"></div>
                        </th:block>
                        <th:block th:if="${iterStat.last and iterStat.count%3==2}">
                            <div class="col-md-4 col-sm-4 blog-main-card"></div>
                        </th:block>
                    </th:block>
                </th:block>
                <th:block th:if="${null != blogPageResult}">
                    <ul class="blog-pagination">
                        <li th:class="${blogPageResult.currPage==1}?'disabled' : ''"><a
                                th:href="@{${blogPageResult.currPage==1}?'##':'/'+${pageUrl}+'/'+${keyword}+'/' + ${blogPageResult.currPage-1}}">&laquo;</a>
                        </li>
                        <li th:if="${blogPageResult.currPage-3 >=1}"><a
                                th:href="@{'/'+${pageUrl}+'/'+${keyword}+'/' + ${blogPageResult.currPage-3}}"
                                th:text="${blogPageResult.currPage -3}">1</a></li>
                        <li th:if="${blogPageResult.currPage-2 >=1}"><a
                                th:href="@{'/'+${pageUrl}+'/'+${keyword}+'/' + ${blogPageResult.currPage-2}}"
                                th:text="${blogPageResult.currPage -2}">1</a></li>
                        <li th:if="${blogPageResult.currPage-1 >=1}"><a
                                th:href="@{'/'+${pageUrl}+'/'+${keyword}+'/' + ${blogPageResult.currPage-1}}"
                                th:text="${blogPageResult.currPage -1}">1</a></li>
                        <li class="active"><a href="#" th:text="${blogPageResult.currPage}">1</a></li>
                        <li th:if="${blogPageResult.currPage+1 <=blogPageResult.totalPage}"><a
                                th:href="@{'/'+${pageUrl}+'/'+${keyword}+'/' + ${blogPageResult.currPage+1}}"
                                th:text="${blogPageResult.currPage +1}">1</a></li>
                        <li th:if="${blogPageResult.currPage+2 <=blogPageResult.totalPage}"><a
                                th:href="@{'/'+${pageUrl}+'/'+${keyword}+'/' + ${blogPageResult.currPage+2}}"
                                th:text="${blogPageResult.currPage +2}">1</a></li>
                        <li th:if="${blogPageResult.currPage+3 <=blogPageResult.totalPage}"><a
                                th:href="@{'/'+${pageUrl}+'/'+${keyword}+'/' + ${blogPageResult.currPage+3}}"
                                th:text="${blogPageResult.currPage +3}">1</a></li>
                        <li th:class="${blogPageResult.currPage==blogPageResult.totalPage}?'disabled' : ''"><a
                                th:href="@{${blogPageResult.currPage==blogPageResult.totalPage}?'##' : '/'+${pageUrl}+'/'+${keyword}+'/' + ${blogPageResult.currPage+1}}">&raquo;</a>
                        </li>
                    </ul>
                </th:block>
            </div>
        </div>
    </div>
</div>
<!-- 引入页脚footer-fragment -->
<footer th:replace="blog/footer::footer-fragment"></footer>
<script th:src="@{/blog/js/jquery.min.js}"></script>
<script th:src="@{/blog/js/bootstrap.min.js}"></script>
<script th:src="@{/blog/js/modernizr.js}"></script>
<script th:src="@{/blog/js/search.js}"></script>
</body>
</html>
```

在博客列表区域和分页功能区域对应的位置读取 blogPageResult 对象中的 list 数据和分页数据，list 数据为博客列表数据，使用 `th:each` 循环语法将标题、预览图、分类数据渲染出来，博客详情页面还没做，a 标签中的详情跳转链接会在博客详情页面功能完善后补上，之后根据分页字段 currPage(当前页码)、 totalPage(总页码)以及 pageUrl 字段将下方的分页按钮渲染出来，列表的渲染与前一个实验相同，唯一不同的地方在于下方分页按钮链接的拼接，由于关键字搜索、分类搜索、标签搜索都是使用该页面用来展示数据，为了避免跳转乱掉就增加了 pageUrl 字段，这样的话他们分别会跳转到对应的搜索链接，不会发生错乱。

修改完成后重启项目查看数据是否正常，如下图所示即为正确的搜索页副标题、博客列表和分页按钮，输入不同的搜索关键字会获得不同的搜索结果，如果是多页数据的话，点击分页按钮则会跳转到对应的页面，分页数据也会发生改变，功能一切正常。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380855525/wm)

# 分类搜索功能实现

#### 页面设计及数据格式定义

结果页面与搜索页面共用一个模板页面，为了区分是哪种搜索方式会在搜索页副标题区域显示不同的字符串，返回的数据格式也相同，只是部分字段的值会有区别，根据关键字搜索时我们会显示**搜索：{keyword}**，分类搜索时我们会显示**分类：{keyword}**，标签搜索时我们会显示**标签：{keyword}**。

#### 发起搜索请求

在前一个实验中我们在介绍首屏页面循环渲染博客列表中的内容时，有介绍到根据分类搜索博客的功能，即点击列表中单个卡片的分类名称或者分类图片则会跳转到分类搜索页，根据分类信息获取当前分类下的博客列表。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380878764/wm)

如上图所示，点击分类信息区域则会进行跳转，首屏页面和搜索结果页面我们都用到了这个页面设计，因此这两个页面的内容都需要修改，只需要修改原来的 a 标签即可，添加分类跳转链接，如下所示：

```
<div class="blog-category">
  <a th:href="@{'/category/' + ${blog.blogCategoryName}}"><!-- 分类搜索链接 -->
     <div class="blog-category-icon">
        <img th:src="@{${blog.blogCategoryIcon}}" alt="">
     </div>
     <div class="blog-category" th:utext="${blog.blogCategoryName}"></div>
 </a>
</div>
```

#### 数据查询实现

接下来是数据查询的功能实现，上述博客列表中的字段可以通过直接查询 tb_blog 文章表和 tb_blog_category 表来获取，同时需要注意分页功能实现，传参时需要传入关键字和页码，实现逻辑如下。

首先，定义 service 方法，业务层代码如下（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）：

```
    /**
     * 根据分类获取首页文章列表
     *
     * @param page
     * @return
     */
    public PageResult getBlogsPageByCategory(String categoryName, int page) {
        if (PatternUtil.validKeyword(categoryName)) {
            BlogCategory blogCategory = categoryMapper.selectByCategoryName(categoryName);
            if ("默认分类".equals(categoryName) && blogCategory == null) {
                blogCategory = new BlogCategory();
                blogCategory.setCategoryId(0);
            }
            if (blogCategory != null && page > 0) {
                Map param = new HashMap();
                param.put("page", page);
                param.put("limit", 9);
                param.put("blogCategoryId", blogCategory.getCategoryId());
                param.put("blogStatus", 1);//过滤发布状态下的数据
                PageQueryUtil pageUtil = new PageQueryUtil(param);
                List<Blog> blogList = blogMapper.findBlogList(pageUtil);
                List<BlogListVO> blogListVOS = getBlogListVOsByBlogs(blogList);
                int total = blogMapper.getTotalBlogs(pageUtil);
                PageResult pageResult = new PageResult(blogListVOS, total, pageUtil.getLimit(), pageUtil.getPage());
                return pageResult;
            }
        }
        return null;
    }
```

我们定义了 `getBlogsPageByCategory()` 方法并传入 categoryName 和 page 参数，categoryName 是分类名称用来过滤想要的文章列表，page 用于确定查询第几页的数据，之后通过 SQL 查询出对应的分页数据，再之后是填充数据，某些字段是 tb_blog 表中没有的，所以再去分类表中查询并设置到 BlogListVO 对象中，最终返回的数据是 PageResult 对象。

具体的 SQL 语句如下（注：完整代码位于 **resources/mapper/BlogMapper.xml**）：

```
    <select id="findBlogList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog
        where is_deleted=0
        <if test="keyword!=null">
            AND (blog_title like CONCAT('%','${keyword}','%' ) or blog_category_name like CONCAT('%','${keyword}','%' ))
        </if>
        <if test="blogStatus!=null">
            AND blog_status = #{blogStatus}
        </if>
       <if test="blogCategoryId!=null">
            AND blog_category_id = #{blogCategoryId}
        </if>
        order by blog_id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalBlogs" parameterType="Map" resultType="int">
        select count(*) from tb_blog
        where is_deleted=0
        <if test="keyword!=null">
            AND (blog_title like CONCAT('%','${keyword}','%' ) or blog_category_name like CONCAT('%','${keyword}','%' ))
        </if>
        <if test="blogStatus!=null">
            AND blog_status = #{blogStatus}
        </if>
        <if test="blogCategoryId!=null">
            AND blog_category_id = #{blogCategoryId}
        </if>
    </select>
```

在原来查询博客列表 SQL 的基础上增加了对于 blogCategoryId 的过滤条件，筛选出当前分类下的文章列表。

#### 数据渲染

想要将数据通过 Thymeleaf 语法渲染到前端页面上，首先需要将数据获取并转发到对应的模板页面中，需要在 Controller 方法中将查询到的数据放入 request 域中，新增 `category()` 方法，代码如下：(**注：完整代码位于 com.site.blog.my.core.controller.blog.MyBlogController.java**)

```
    /**
     * 分类列表页
     *
     * @return
     */
    @GetMapping({"/category/{categoryName}"})
    public String category(HttpServletRequest request, @PathVariable("categoryName") String categoryName) {
        return category(request, categoryName, 1);
    }

    /**
     * 分类列表页
     *
     * @return
     */
    @GetMapping({"/category/{categoryName}/{page}"})
    public String category(HttpServletRequest request, @PathVariable("categoryName") String categoryName, @PathVariable("page") Integer page) {
        PageResult blogPageResult = blogService.getBlogsPageByCategory(categoryName, page);
        request.setAttribute("blogPageResult", blogPageResult);
        request.setAttribute("pageName", "分类");
        request.setAttribute("pageUrl", "category");
        request.setAttribute("keyword", categoryName);
        return "blog/list";
    }
```

路径映射为 /category/{categoryName}/{page}，`page` 参数不传的话默认为第 1 页，根据页码和关键字查询出对应的分页数据 blogPageResult 并放入到 request 对象中，之后跳转到 list 模板页面进行数据渲染，需要注意的是 `pageName` 字段、 `pageUrl` 字段和 `keyword` 字段，这些字段主要是为了搜索页副标题区域的显示和翻页链接的拼接。这里可以将这些字段的值与关键字搜索功能时的值相比较，关键字搜索中 `pageName` 的值为**搜索**，而此时 `pageName` 的值为**分类**，`pageUrl` 参数的值也由 **search** 变成了 **category**，`pageUrl` 参数的值都与请求路径映射的第一级目录相同，`pageUrl` 主要是为了下方分页按钮的路径跳转链接的生成，关键字搜索出的分页结果中分页按钮会跳转关键字搜索的链接 **/search/{keyword}/{page}**，分类搜索出的分页结果中分页按钮会跳转分类搜索的链接 **/category/{categoryName}/{page}** 。

前端模板文件为 list.html，就不多做介绍了，修改完成后重启项目查看数据是否正常，如下图所示即为正确的搜索页副标题、博客列表和分页按钮，点击不同的分类信息会跳转到搜索页面同时也会获得不同的分类搜索结果，如果是多页数据的话，点击分页按钮则会跳转到对应的页面，分页数据也会发生改变，功能一切正常。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380903497/wm)

# 标签搜索功能实现

#### 页面设计及数据格式定义

结果页面与搜索页面共用一个模板页面，为了区分是哪种搜索方式会在搜索页副标题区域显示不同的字符串，返回的数据格式也相同，只是部分字段的值会有区别，根据关键字搜索时我们会显示**搜索：{keyword}**，分类搜索时我们会显示**分类：{keyword}**，标签搜索时我们会显示标签**：{keyword}**。

#### 发起搜索请求

在前一个实验中我们在介绍首屏页面循环渲染标签栏中的标签内容时，有介绍到根据标签搜索博客的功能，即点击列表中的标签名称则会跳转到标签搜索页面，根据标签信息获取当前使用该标签的博客列表。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380936004/wm)

如上图所示，点击每个标签时则会进行跳转，除了首页的标签栏之外，在后面的博客详情页我们也会展示标签信息，所以在详情页面也会有跳转的逻辑，只需要修改原来的 a 标签即可，添加标签跳转链接，如下所示：

```
    <ul class="tags">
        <th:block th:if="${null != hotTags}">
            <th:block th:each="hotTag : ${hotTags}">
                <li><a th:href="@{'/tag/' + ${hotTag.tagName}}"><!-- 标签搜索链接 -->
                        <th:block th:text="${hotTag.tagName}+'('+${hotTag.tagCount}+')'"></th:block>
                    </a>
                </li>
            </th:block>
        </th:block>
    </ul>
```

#### 数据查询实现

接下来是数据查询的功能实现，由于博客表与标签表的设计原因，在数据查询时会首先查询标签信息是否正确，之后进行 tb_blog 博客表和 tb_blog_tag_relation 关系表的连接查询将符合条件的博客记录过滤出来，之后再进行数据填充，该搜索功能会涉及到 4 张表的查询，同时需要注意分页功能实现，传参时需要传入关键字和页码，实现逻辑如下。

首先，定义 service 方法，业务层代码如下（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）：

```
    /**
     * 根据标签获取首页文章列表
     *
     * @param page
     * @return
     */
  public PageResult getBlogsPageByTag(String tagName, int page) {
        if (PatternUtil.validKeyword(tagName)) {
            BlogTag tag = tagMapper.selectByTagName(tagName);
            if (tag != null && page > 0) {
                Map param = new HashMap();
                param.put("page", page);
                param.put("limit", 9);
                param.put("tagId", tag.getTagId());
                PageQueryUtil pageUtil = new PageQueryUtil(param);
                List<Blog> blogList = blogMapper.getBlogsPageByTagId(pageUtil);
                List<BlogListVO> blogListVOS = getBlogListVOsByBlogs(blogList);
                int total = blogMapper.getTotalBlogsByTagId(pageUtil);
                PageResult pageResult = new PageResult(blogListVOS, total, pageUtil.getLimit(), pageUtil.getPage());
                return pageResult;
            }
        }
        return null;
    }
```

我们定义了 `getBlogsPageByTag()` 方法并传入 `tagName` 和 `page` 参数，`tagName` 是标签名称用来过滤想要的文章列表，`page` 用于确定查询第几页的数据，之后通过 SQL 查询出对应的分页数据，再之后是填充数据，某些字段是 tb_blog 表中没有的，所以再去分类表中查询并设置到 BlogListVO 对象中，最终返回的数据是 PageResult 对象。

具体的 SQL 语句如下（注：完整代码位于 **resources/mapper/BlogMapper.xml**）：

```
    <select id="getBlogsPageByTagId" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog
        where blog_id IN (SELECT blog_id FROM tb_blog_tag_relation WHERE tag_id = #{tagId})
        AND blog_status =1 AND is_deleted=0
        order by blog_id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalBlogsByTagId" parameterType="Map" resultType="int">
        select count(*)
        from tb_blog
        where  blog_id IN (SELECT blog_id FROM tb_blog_tag_relation WHERE tag_id = #{tagId})
        AND blog_status =1 AND is_deleted=0
    </select>
```

首先根据 tag_id 在关系表中过滤出符合条件的 blog_id 集合，之后使用 IN 关键字再次进行过滤筛选出当前标签下的文章列表。

#### 数据渲染

想要将数据通过 Thymeleaf 语法渲染到前端页面上，首先需要将数据获取并转发到对应的模板页面中，需要在 Controller 方法中将查询到的数据放入 request 域中，新增 tag() 方法，代码如下：(**注：完整代码位于 com.site.blog.my.core.controller.blog.MyBlogController**)

```
    /**
     * 标签列表页
     *
     * @return
     */
    @GetMapping({"/tag/{tagName}"})
    public String tag(HttpServletRequest request, @PathVariable("tagName") String tagName) {
        return tag(request, tagName, 1);
    }

    /**
     * 标签列表页
     *
     * @return
     */
    @GetMapping({"/tag/{tagName}/{page}"})
    public String tag(HttpServletRequest request, @PathVariable("tagName") String tagName, @PathVariable("page") Integer page) {
        PageResult blogPageResult = blogService.getBlogsPageByTag(tagName, page);
        request.setAttribute("blogPageResult", blogPageResult);
        request.setAttribute("pageName", "标签");
        request.setAttribute("pageUrl", "tag");
        request.setAttribute("keyword", tagName);
        return "blog/list";
    }
```

路径映射为 /tag/{tagName}/{page}，page 参数不传的话默认为第 1 页，根据页码和关键字查询出对应的分页数据 blogPageResult 并放入到 request 对象中，之后跳转到 list 模板页面进行数据渲染，需要注意的是 `pageName` 字段、 `pageUrl` 字段和 `keyword` 字段，这些字段主要是为了搜索页副标题区域的显示和翻页链接的拼接。在这里可以将这些字段的值与关键字搜索功能时的值相比较，关键字搜索中 `pageName` 的值为**搜索**，而此时 `pageName` 的值为**标签**，`pageUrl` 参数的值也由 **search** 变成了 **tag**，`pageUrl` 参数的值都与请求路径映射的第一级目录相同，`pageUrl` 主要是为了下方分页按钮的路径跳转链接的生成，关键字搜索出的分页结果中分页按钮会跳转关键字搜索的链接 **/search/{keyword}/{page}**，标签搜索出的分页结果中分页按钮会跳转分类搜索的链接 **/tag/{tagName}/{page}** 。

前端模板文件为 list.html，就不多做介绍了，修改完成后重启项目查看数据是否正常，如下图所示即为正确的搜索页副标题、博客列表和分页按钮，点击不同的标签信息会跳转到搜索页面同时也会获得不同的搜索结果，如果是多页数据的话，点击分页按钮则会跳转到对应的页面，分页数据也会发生改变，功能一切正常。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380961654/wm)

# 总结

博客页面所有的搜索功能，包括搜索框搜索(关键字搜索)、按照分类搜索、按照标签搜索，首先讲到了页面设计以及数据格式的定义，之后又分别讲述如何发起这些搜索请求并完善了之前的首屏页面逻辑，之后就是 SQL 查询语句的介绍以及三个搜索方法的入参和结果返回的介绍，搜索功能是一个博客系统不可缺少的功能，希望大家可以理解本实验中的搜索功能的知识点。

本节实验到此结束，同学们可以按照文中的思路和过程自行测试。