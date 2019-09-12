# 实验介绍

#### 实验内容

首页的前端页面编码完成，但是页面上都是静态数据，并没有与后端交互进行实际数据的读取和渲染，本节实验将会讲解首屏页面上数据的查询，以及如何将这些数据填充到页面中，前面一个实验更多的偏重于页面制作，本文则是数据填充和功能实现，数据主要有左侧功能栏中的博客统计列表数据、标签栏数据、首页文章列表数据以及分页功能实现。

#### 实验知识点

- 最新发布
- 点击最多
- 文章列表
- 分页功能

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-26.zip
unzip My-Blog-26.zip
cd My-Blog
```

# 点击最多、最新发布

#### 数据格式定义

首先，我们把侧边栏中**点击最多**和**最新发布**两个栏目中的数据填充完成，数据填充之前，我们需要确认一下这两个栏目中的数据格式是怎样的，如下图中第四部分，这里以**点击最多**为例，通过图中的信息可以得出，这是一个博客列表，所以后端肯定会返回一个 List 格式的对象，展示的数据仅仅为博客标题，即**哪些博客是点击量比较高的**，同理，**最新发布**栏目中即为**哪些博客是发布时间较新的**。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380639778/wm)

虽然通过图片我们只能看出一个博客标题字段，但是这里通常会设计成可跳转的形式，即点击标题后会跳转到对应的博客详情页面中，因此还需要一个博客实体的 id 字段，因此返回数据的格式就得出来了，编码如下：

```
package com.site.blog.my.core.controller.vo;
import java.io.Serializable;
public class SimpleBlogListVO implements Serializable {

    private Long blogId;

    private String blogTitle;

    public Long getBlogId() {
        return blogId;
    }

    public void setBlogId(Long blogId) {
        this.blogId = blogId;
    }

    public String getBlogTitle() {
        return blogTitle;
    }

    public void setBlogTitle(String blogTitle) {
        this.blogTitle = blogTitle;
    }
}
```

#### 数据查询实现

接下来是数据查询的功能实现，上述两种类型的博客列表都是可以通过直接查询 tb_blog 文章表来获取，只不过查询时使用到的字段不同，一个会使用到浏览量字段，一个是使用创建时间字段，实现逻辑如下。

首先，定义 service 方法，业务层代码如下（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）：

```
    /**
     * 首页侧边栏数据列表
     * 0-点击最多 1-最新发布
     *
     * @param type
     * @return
     */    
    public List<SimpleBlogListVO> getBlogListForIndexPage(int type) {
        List<SimpleBlogListVO> simpleBlogListVOS = new ArrayList<>();
        List<Blog> blogs = blogMapper.findBlogListByType(type, 9);
        if (!CollectionUtils.isEmpty(blogs)) {
            for (Blog blog : blogs) {
                SimpleBlogListVO simpleBlogListVO = new SimpleBlogListVO();
                BeanUtils.copyProperties(blog, simpleBlogListVO);
                simpleBlogListVOS.add(simpleBlogListVO);
            }
        }
        return simpleBlogListVOS;
    }
```

我们定义了 `getBlogListForIndexPage()` 方法并定义 type 参数，type 等于 0 时为查询**点击最多**的博客列表，type 等于 1 时为查询**最新发布**的博客列表，返回的数据格式为 SimpleBlogListVO，方法逻辑实现为：首先根据 type 字段的不同去查询对应的博客列表，但是查询出来的数据类型为 Blog，之后将 Blog 类型的数据转换为 SimpleBlogListVO 并返回即可。

具体的 SQL 语句如下（注：完整代码位于 **resources/mapper/BlogMapper.xml**）：

```
    <select id="findBlogListByType" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog
        where is_deleted=0 AND blog_status = 1<!-- 发布状态的文章 -->
        <if test="type!=null and type==0">
            order by blog_views desc
        </if>
        <if test="type!=null and type==1">
            order by blog_id desc
        </if>
        limit #{limit}
    </select>
```

#### 数据渲染

想要将数据通过 Thymeleaf 语法渲染到前端页面上，首先需要将数据带过来，需要在首页请求的 Controller 方法中将查询到的数据放入 request 域中，代码修改如下：(**注：完整代码位于 com.site.blog.my.core.controller.blog.MyBlogController.java**)

```
    @GetMapping({"/", "/index", "index.html"})
    public String index(HttpServletRequest request) {
        request.setAttribute("newBlogs", blogService.getBlogListForIndexPage(1));
        request.setAttribute("hotBlogs", blogService.getBlogListForIndexPage(0));
        request.setAttribute("pageName", "首页");
        return "blog/index";
    }
```

分别查出最新发布的博客列表和点击最多的博客列表并放入到 request 对象中，分别取名为 newBlogs 和 hotBlogs，之后跳转到 index 模板页面进行数据渲染。

index.html 文件修改如下：(**注：完整代码位于 resources/templates/blog/index.html**)

```
    <div class="aside-widget">
        <header>
            <h3>点击最多</h3>
        </header>
        <div class="body">
            <ul class="clean-list">
                <th:block th:if="${null != hotBlogs}">
                    <th:block th:each="hotBlog : ${hotBlogs}">
                        <li><a>
                            <th:block th:text="${hotBlog.blogTitle}"></th:block>
                        </a></li>
                    </th:block>
                </th:block>
            </ul>
        </div>
    </div>
    <div class="aside-widget">
        <header>
            <h3>最新发布</h3>
        </header>
        <div class="body">
            <ul class="clean-list">
                <th:block th:if="${null != newBlogs}">
                    <th:block th:each="newBlog : ${newBlogs}">
                        <li><a>
                            <th:block th:text="${newBlog.blogTitle}"></th:block>
                        </a></li>
                    </th:block>
                </th:block>
            </ul>
        </div>
    </div>
```

在**点击最多**栏目和**最新发布**栏目对应的位置读取 hotBlogs 和 newBlogs，并使用 `th:each` 循环语法将标题渲染出来，由于博客详情页面还没做，a 标签中的详情跳转链接暂时就不写了，之后会在博客详情页面功能完善后补上。

之后重启项目查看数据是否正常，如下图所示即为正确的侧边栏数据展示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380659863/wm)

# 标签栏

#### 数据格式定义

数据填充之前，我们需要确认一下数据格式是怎样的，如下图中第五部分，通过图中的信息可以得出，这是一个标签名称的列表，展示的数据为标签的名称，但是这样的话数据有些单薄，所以在这个原型图的基础上我又加上了每个标签对应的有多少篇文章在使用，因此这里显示的会是标签的名称和对应的博客数量两个字段。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380670025/wm)

当然这里通常也会设计成可跳转的形式，即点击标签后会跳转到对应的该标签下的博客列表中，因此还需要一个标签的主键字段，因此返回数据的格式就得出来了，编码如下：

```
package com.site.blog.my.core.entity;
public class BlogTagCount {

    private Integer tagId;

    private String tagName;

    private Integer tagCount;


    public Integer getTagId() {
        return tagId;
    }

    public void setTagId(Integer tagId) {
        this.tagId = tagId;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }

    public Integer getTagCount() {
        return tagCount;
    }

    public void setTagCount(Integer tagCount) {
        this.tagCount = tagCount;
    }
}
```

#### 数据查询实现

通过前文中的数据格式定义我们也大致的清楚了我们需要查询的是什么数据，但是我们也不可能把所有的标签数据都查出来，因为数据量太大的话全部显示在页面会有些怪，所以标签栏的数据我设计成了查询当前使用最多的 20 个标签数据，这个数据的获取会比较复杂，因为标签和文章会涉及到三张表的操作：tb_blog 表、tb_blog_tag 表以及 tb_blog_tag_relation 表。

首先，定义 service 方法，业务层代码如下（注：完整代码位于 **com.site.blog.my.core.service.impl.TagServiceImpl.java**）：

```
    public List<BlogTagCount> getBlogTagCountForIndex() {
        return blogTagMapper.getTagCount();
    }
```

我们定义了 `getBlogTagCountForIndex()` 方法，实现逻辑是直接返回 `blogTagMapper.getTagCount()` 执行后的返回数据，该方法其实并没有做什么逻辑，实现的难点都在 SQL 语句。

具体的 SQL 语句如下（注：完整代码位于 **resources/mapper/BlogTagMapper.xml**）：

首先在 Mapper 文件中添加一个 ResultMap，代码如下：

```
    <resultMap id="BaseCountResultMap" type="com.site.blog.my.core.entity.BlogTagCount">
        <id column="tag_id" jdbcType="INTEGER" property="tagId"/>
        <result column="tag_count" jdbcType="INTEGER" property="tagCount"/>
        <result column="tag_name" jdbcType="VARCHAR" property="tagName"/>
    </resultMap>
```

之后是 `getTagCount()` 方法的 SQL 具体实现，代码如下：

```
    <select id="getTagCount" resultMap="BaseCountResultMap">
        SELECT t_r.*,t.tag_name FROM
        (SELECT r.tag_id,r.tag_count FROM
         (SELECT tag_id ,COUNT(*) AS tag_count FROM
          (SELECT tr.tag_id FROM tb_blog_tag_relation tr LEFT JOIN tb_blog b ON tr.blog_id = b.blog_id WHERE b.is_deleted=0)
            trb GROUP BY tag_id) r ORDER BY tag_count DESC LIMIT 20 ) AS t_r LEFT JOIN tb_blog_tag t ON t_r.tag_id = t.tag_id WHERE t.is_deleted=0
    </select>
```

以上就是查询当前使用最多的 20 个标签数据的 SQL 语句，用到了连接查询以及聚合方法，看起来有些复杂，查询的层级也深，这里告诉大家该怎么更好的理解该 SQL，虽然查询层级深，在学习时也要一层一层的去执行和理解。

- **第一层 SQL：**

```
SELECT tr.tag_id FROM tb_blog_tag_relation tr LEFT JOIN tb_blog b ON tr.blog_id = b.blog_id WHERE b.is_deleted=0
```

 tb_blog_tag_relation 表和 tb_blog 表通过 blog_id 字段进行左连接查询，主要是为了过滤掉已删除博客记录的关联数据。

- **第二层 SQL：**

```
SELECT tag_id ,COUNT(*) AS tag_count FROM
          (SELECT tr.tag_id FROM tb_blog_tag_relation tr LEFT JOIN tb_blog b ON tr.blog_id = b.blog_id WHERE b.is_deleted=0) trb GROUP BY tag_id
```

 直接根据第一层查询后的数据进行操作，并使用 GROUP BY tag_id 来进行数量统计，这一层 SQL 执行后返回的数据是标签的主键 tag_id 以及该主键下共有多少条关系数据。

- **第三层 SQL：**

```
SELECT r.tag_id,r.tag_count FROM
         (SELECT tag_id ,COUNT(*) AS tag_count FROM
          (SELECT tr.tag_id FROM tb_blog_tag_relation tr LEFT JOIN tb_blog b ON tr.blog_id = b.blog_id WHERE b.is_deleted=0)
            trb GROUP BY tag_id) r ORDER BY tag_count DESC LIMIT 20
```

 直接根据第二层查询后的数据进行操作，主要是根据 tag_count 进行排序同时取出数量最多的 20 条数据。

1. **第四层 SQL：**

   即是前文中写在 Mapper 文件中的 SQL 语句，这一层主要是对第三层查询后的数据与 tb_blog_tag 标签表做连接查询，把前一步查询出的 20 条记录的标签名称查出。

**如果有同学对这个 SQL 恐惧的话可以按照十三给出的步骤去理解，当然，最好是按照十三给出的每一层的 SQL 去实际的查询，这样才能更好的理解这些查询的含义。**

#### 数据渲染

首先要在首页请求的 Controller 方法中将查询到的数据放入 request 域中，代码修改如下：(**注：完整代码位于 com.site.blog.my.core.controller.blog.MyBlogController.java**)

```
    @GetMapping({"/", "/index", "index.html"})
    public String index(HttpServletRequest request) {
        request.setAttribute("newBlogs", blogService.getBlogListForIndexPage(1));
        request.setAttribute("hotBlogs", blogService.getBlogListForIndexPage(0));
        request.setAttribute("hotTags", tagService.getBlogTagCountForIndex());
        request.setAttribute("pageName", "首页");
        return "blog/index";
    }
```

查出标签统计数据并放入到 request 对象中，对象命名为 hotTags，之后跳转到 index 模板页面进行数据渲染。

index.html 文件修改如下：(**注：完整代码位于 resources/templates/blog/index.html**)

```
    <div class="aside-widget">
        <header>
            <h3>标签栏</h3>
        </header>
        <div class="body clearfix">
            <ul class="tags">
                <th:block th:if="${null != hotTags}">
                    <th:block th:each="hotTag : ${hotTags}">
                        <li>
                            <a>
                                <th:block th:text="${hotTag.tagName}+'('+${hotTag.tagCount}+')'"></th:block>
                            </a>
                        </li>
                    </th:block>
                </th:block>
            </ul>
        </div>
    </div>
```

在**标签栏**栏目对应的位置读取 hotTags 对象，并使用 `th:each` 循环语法将表情的名称和数量渲染出来，a 标签中的跳转链接暂时就不写了，之后会在博客搜索功能完善后补上。

之后重启项目查看数据是否正常，如下图所示即为正确的侧边栏数据展示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380696489/wm)

# 博客列表

#### 数据格式定义

接下来就是我们本次实验的最后一个部分，也是较为复杂的一部分--**首页博客列表和分页功能实现**，这两部分需要填充的数据就是博客列表和分页按钮以及跳转逻辑，分页按钮中并没有需要定义的数据格式，只是把页码放上去即可，我们主要确认一下博客列表中的数据格式是怎样的，如下图所示，即为首页博客列表中需要渲染的内容。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380707896/wm)

首先博客列表肯定是一个 List 对象，但是因为有分页功能，所以还需要返回分页字段，因此最终接收到的结果返回格式为 PageResult 对象，而列表中的单项对象中的字段则需要通过下图中的内容进行确认。

通过图片我们可以看到博客标题字段、预览图字段、分类名称字段、分类图片字段，当然这里通常会设计成可跳转的形式，即点击标题或者预览图后会跳转到对应的博客详情页面中，点击分类名称或者分类图片也会跳转到对应的博客分类页面，因此还需要一个博客实体的 id 字段和分类实体的 id 字段，因此返回数据的格式就得出来了，编码如下：

```
package com.site.blog.my.core.controller.vo;

import java.io.Serializable;

public class BlogListVO implements Serializable {

    private Long blogId;

    private String blogTitle;

    private String blogCoverImage;

    private Integer blogCategoryId;

    private String blogCategoryIcon;

    private String blogCategoryName;

    public Long getBlogId() {
        return blogId;
    }

    public void setBlogId(Long blogId) {
        this.blogId = blogId;
    }

    public String getBlogTitle() {
        return blogTitle;
    }

    public void setBlogTitle(String blogTitle) {
        this.blogTitle = blogTitle;
    }

    public String getBlogCoverImage() {
        return blogCoverImage;
    }

    public void setBlogCoverImage(String blogCoverImage) {
        this.blogCoverImage = blogCoverImage;
    }

    public Integer getBlogCategoryId() {
        return blogCategoryId;
    }

    public void setBlogCategoryId(Integer blogCategoryId) {
        this.blogCategoryId = blogCategoryId;
    }

    public String getBlogCategoryName() {
        return blogCategoryName;
    }

    public void setBlogCategoryName(String blogCategoryName) {
        this.blogCategoryName = blogCategoryName;
    }

    public String getBlogCategoryIcon() {
        return blogCategoryIcon;
    }

    public void setBlogCategoryIcon(String blogCategoryIcon) {
        this.blogCategoryIcon = blogCategoryIcon;
    }
}
```

#### 数据查询实现

接下来是数据查询的功能实现，上述博客列表中的字段可以通过直接查询 tb_blog 文章表和 tb_blog_category 表来获取，同时需要注意分页功能实现，传参时也需要传上此时的页码，首页默认是第 1 页，实现逻辑如下。

首先，定义 service 方法，业务层代码如下（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）：

```
    /**
     * 获取首页文章列表
     *
     * @param page
     * @return
     */
    public PageResult getBlogsForIndexPage(int page) {
        Map params = new HashMap();
        params.put("page", page);
        //每页8条
        params.put("limit", 8);
        params.put("blogStatus", 1);//过滤发布状态下的数据
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        List<Blog> blogList = blogMapper.findBlogList(pageUtil);
        List<BlogListVO> blogListVOS = getBlogListVOsByBlogs(blogList);
        int total = blogMapper.getTotalBlogs(pageUtil);
        PageResult pageResult = new PageResult(blogListVOS, total, pageUtil.getLimit(), pageUtil.getPage());
        return pageResult;
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

我们定义了 `getBlogsForIndexPage()` 方法并定义 page 参数来确定查询第几页的数据，之后通过 SQL 查询出对应的分页数据，再之后是填充数据，某些字段是 tb_blog 表中没有的，所以再去分类表中查询并设置到 BlogListVO 对象中，最终返回的数据是 PageResult 对象。

具体的 SQL 语句如下（注：完整代码位于 **resources/mapper/BlogMapper.xml**）：

```
    <select id="findBlogList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog
        where is_deleted=0
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
        <if test="blogStatus!=null">
            AND blog_status = #{blogStatus}
        </if>
    </select>
```

在原来查询博客列表 SQL 的基础上增加了对于 blog_status 字段的过滤，因为首页肯定显示已发布状态的博客。

#### 数据渲染

想要将数据通过 Thymeleaf 语法渲染到前端页面上，首先需要将数据带过来，需要在首页请求的 Controller 方法中将查询到的数据放入 request 域中，因为有分页逻辑，所以需要对原首页跳转方法进行修改，代码修改如下：(**注：完整代码位于 com.site.blog.my.core.controller.blog.MyBlogController.java**)

```
    /**
     * 首页(取第一页数据)
     *
     * @return
     */
    @GetMapping({"/", "/index", "index.html"})
    public String index(HttpServletRequest request) {
        return this.page(request, 1);
    }

    /**
     * 首页 分页数据
     *
     * @return
     */
    @GetMapping({"/page/{pageNum}"})
    public String page(HttpServletRequest request, @PathVariable("pageNum") int pageNum) {
        PageResult blogPageResult = blogService.getBlogsForIndexPage(pageNum);
        if (blogPageResult == null) {
            return "error/error_404";
        }
        request.setAttribute("blogPageResult", blogPageResult);
        request.setAttribute("newBlogs", blogService.getBlogListForIndexPage(1));
        request.setAttribute("hotBlogs", blogService.getBlogListForIndexPage(0));
        request.setAttribute("hotTags", tagService.getBlogTagCountForIndex());
        request.setAttribute("pageName", "首页");
        return "blog/index";
    }
```

添加了 `page()` 方法用于处理分页逻辑，原来的逻辑处理都放在了该方法中，首页方法是第 1 页的数据，所以默认调用 `page()` 方法的第 1 页即可，根据页码查询出对应的分页数据 blogPageResult 并放入到 request 对象中，之后跳转到 index 模板页面进行数据渲染。

index.html 文件修改如下：(**注：完整代码位于 resources/templates/blog/index.html**)

```
<div class="col-md-8 blog-main">
    <th:block th:if="${null != blogPageResult}">
        <th:block th:each="blog,iterStat : ${blogPageResult.list}">
            <div class="col-md-6 col-sm-6 blog-main-card">
                <article class="blog-summary">
                    <header>
                        <a>
                            <img th:src="@{${blog.blogCoverImage}}" alt="">
                            <h3>
                                <th:block th:text="${blog.blogTitle}"></th:block>
                            </h3>
                        </a>
                        <div class="blog-category">
                            <a>
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
            <th:block th:if="${iterStat.last and iterStat.count%2==1}">
                <div class="col-md-6 col-sm-6 blog-main-card">
                </div>
            </th:block>
        </th:block>
    </th:block>
    <th:block th:if="${null != blogPageResult}">
        <ul class="blog-pagination">
            <li th:class="${blogPageResult.currPage==1}?'disabled' : ''"><a
                    th:href="@{${blogPageResult.currPage==1}?'##':'/page/' + ${blogPageResult.currPage-1}}">&laquo;</a>
            </li>
            <li th:if="${blogPageResult.currPage-3 >=1}"><a
                    th:href="@{'/page/' + ${blogPageResult.currPage-3}}"
                    th:text="${blogPageResult.currPage -3}">1</a></li>
            <li th:if="${blogPageResult.currPage-2 >=1}"><a
                    th:href="@{'/page/' + ${blogPageResult.currPage-2}}"
                    th:text="${blogPageResult.currPage -2}">1</a></li>
            <li th:if="${blogPageResult.currPage-1 >=1}"><a
                    th:href="@{'/page/' + ${blogPageResult.currPage-1}}"
                    th:text="${blogPageResult.currPage -1}">1</a></li>
            <li class="active"><a href="#" th:text="${blogPageResult.currPage}">1</a></li>
            <li th:if="${blogPageResult.currPage+1 <=blogPageResult.totalPage}"><a
                    th:href="@{'/page/' + ${blogPageResult.currPage+1}}"
                    th:text="${blogPageResult.currPage +1}">1</a></li>
            <li th:if="${blogPageResult.currPage+2 <=blogPageResult.totalPage}"><a
                    th:href="@{'/page/' + ${blogPageResult.currPage+2}}"
                    th:text="${blogPageResult.currPage +2}">1</a></li>
            <li th:if="${blogPageResult.currPage+3 <=blogPageResult.totalPage}"><a
                    th:href="@{'/page/' + ${blogPageResult.currPage+3}}"
                    th:text="${blogPageResult.currPage +3}">1</a></li>
            <li th:class="${blogPageResult.currPage==blogPageResult.totalPage}?'disabled' : ''"><a
                    th:href="@{${blogPageResult.currPage==blogPageResult.totalPage}?'##' : '/page/' + ${blogPageResult.currPage+1}}">&raquo;</a>
            </li>
        </ul>
    </th:block>
</div>
```

在博客列表区域和分页功能区域对应的位置读取 blogPageResult 对象中的 list 数据和分页数据，list 数据为博客列表数据，使用 `th:each` 循环语法将标题、预览图、分类数据渲染出来，博客详情页面还没做，a 标签中的详情跳转链接会在博客详情页面功能完善后补上，之后根据分页字段 currPage(当前页码)和 totalPage(总页码)将下方的分页按钮渲染出来。

修改完成后重启项目查看数据是否正常，如下图所示即为正确的博客列表和分页按钮，点击分页按钮则会跳转到对应的页面，分页数据也会发生改变，功能一切正常。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380730301/wm)

# 总结

本节实验将会讲解数据的查询以及如何填充到页面中，并分成三个部分分别讲解了侧边栏、标签栏、博客列表、分页按钮这些数据的查询以及页面渲染，其中的一些难点文中也都一一作出了解释，希望不理解的同学多看几遍，最重要的功能是分页，与后台管理系统中使用 JqGrid 插件实现分页不同，博客页面的分页并没有借助第三方插件，而是使用 Thymeleaf 标签以及判断语句根据页码字段渲染出分页按钮。最后提醒一下，分页功能的测试，最好在数据库中增加一些博客记录，这样才会更好的测试该功能。

本节实验到此结束，同学们可以按照文中的思路和过程自行测试。