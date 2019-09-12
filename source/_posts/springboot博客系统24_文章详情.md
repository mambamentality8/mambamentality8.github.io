# 实验介绍

#### 实验内容

在前面几个实验中我们一直有提到文章详情页，因为训练营课程安排顺序的缘故，博客详情页被安排在了后面一些，详情页还没有制作完成所以有些 a 标签中的跳转链接地址无法填上，这个实验就来该开发文章详情页的相关功能了，我会从页面设计和排版讲起，之后是功能实现和页面优化。

#### 实验知识点

- 详情页页面设计
- 详情查询功能实现及页面渲染
- markdown 格式转换
- 页面优化

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-28.zip
unzip My-Blog-28.zip
cd My-Blog
```

# 详情功能实现

#### 页面设计

大家也常常浏览各个博客网站，应该能够看出来其实文章详情最重要的就是文章内容的展示，以及文章其他相关字段的展示，比如标签、浏览量之类的信息也会在文章详情页进行展示，接下来我们看一下我们这个博客系统最终的文章详情页展现效果来确认该页面的布局设计，如下图所示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381057151/wm)

顶部导航栏和底部页脚区域是所有页面都有的页面元素，属于公共区域，这里就不再赘述，截图中也只是文章详情的功能展示区域，重点关注一下图中标注的四个地方,如上图所示，分别标注了四个区域，从上至下依次为：

1. **文章的分类信息展示区域**：主要用于放置分类名称和分类图标字段；
2. **文章标题区域**：放置文章标题，字体相较于其他部分会大很多；
3. **文章的基础信息区域**：放置文章的标签、时间、浏览量等字段；
4. **文章详情区域**：文章内容的展示区域，以上三个区域通常是固定的，而文章详情区域则会因为文章内容的多少动态的变化，内容多则占用的版面就多，反之就会少一些。

页面中还会有**文章的评论列表区域**和**文章评论的输入区域**，在本次实验中暂时就不介绍了，后面会单独用一个章节来开发博客的评论模块。

当然，以上版面设计的分析只是对于我的博客模板来说是这样的，社区中还有许多其他的博客系统项目，由于前端的设计和实现非常灵活且多变，这些博客系统可能又是另外一些页面样式和页面布局，比如我们的博客系统就有三个页面模板，不同的模板就会有不同的样式。

#### 数据格式定义

通过上面的图片我们也能够看出文章详情页需要的字段，包括文章标题、文章标签、文章分类、文章内容等等字段，基本上文章表中的字段都用到了，返回数据的格式很清晰，编码如下：

```
package com.site.blog.my.core.controller.vo;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class BlogDetailVO implements Serializable {
    private Long blogId;

    private String blogTitle;

    private Integer blogCategoryId;

    private Integer commentCount;

    private String blogCategoryIcon;

    private String blogCategoryName;

    private String blogCoverImage;

    private Long blogViews;

    private List<String> blogTags;

    private String blogContent;

    private Byte enableComment;

    private Date createTime;
}
```

#### 详情页跳转

详情页通常是通过点击博客列表页中的单个卡片中的链接跳转而来的，首页中以及搜素页面中会有这些跳转链接，详情页的路径我们定义为 **/blog/{blogId}**，首先我们来修改首页模板代码及搜索页模板代码，添加 a 标签中的详情页跳转路径，修改如下：

1. **index.html 博客列表**

```
<a th:href="@{'/blog/' + ${blog.blogId}}">
   <img th:src="@{${blog.blogCoverImage}}" alt="">
     <h3><th:block th:text="${blog.blogTitle}"></th:block></h3>
</a>
```

1. **index .html 点击最多**

```
<li>
    <a th:href="@{'/blog/' + ${hotBlog.blogId}}">
      <th:block th:text="${hotBlog.blogTitle}"></th:block>
    </a>
</li>
```

1. **index .html 最新发布**

```
<li>
    <a th:href="@{'/blog/' + ${newBlog.blogId}}">
      <th:block th:text="${newBlog.blogTitle}"></th:block>
    </a>
</li>
```

1. **index.html 博客列表**

```
<a th:href="@{'/blog/' + ${blog.blogId}}">
   <img th:src="@{${blog.blogCoverImage}}" alt="">
     <h3><th:block th:text="${blog.blogTitle}"></th:block></h3>
</a>
```

链接添加后，在点击后就会跳转到详情页面，接下来是详情页的功能实现讲解。

#### 数据查询实现

首先，是数据查询的功能实现，上述详情页面中的字段可以通过直接查询 tb_blog 文章表和 tb_blog_category 分类表来获取，传参时只需要传入文章的主键 id 即可，实现逻辑如下。

定义 service 方法，业务层代码如下（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）：

```
    /**
     * 文章详情获取
     * 
     * @param blogId
     * @return
     */    
    public BlogDetailVO getBlogDetail(Long blogId) {
        Blog blog = blogMapper.selectByPrimaryKey(blogId);
        //不为空且状态为已发布
        BlogDetailVO blogDetailVO = getBlogDetailVO(blog);
        if (blogDetailVO != null) {
            return blogDetailVO;
        }
        return null;
    }

    /**
     * 方法抽取
     *
     * @param blog
     * @return
     */
    private BlogDetailVO getBlogDetailVO(Blog blog) {
        //判空以及发布状态是否为已发布
        if (blog != null && blog.getBlogStatus() == 1) {
            //增加浏览量
            blog.setBlogViews(blog.getBlogViews() + 1);
            blogMapper.updateByPrimaryKey(blog);
            BlogDetailVO blogDetailVO = new BlogDetailVO();
            BeanUtils.copyProperties(blog, blogDetailVO);
            //md格式转换
            blogDetailVO.setBlogContent(MarkDownUtil.mdToHtml(blogDetailVO.getBlogContent()));
            BlogCategory blogCategory = categoryMapper.selectByPrimaryKey(blog.getBlogCategoryId());
            if (blogCategory == null) {
                blogCategory = new BlogCategory();
                blogCategory.setCategoryId(0);
                blogCategory.setCategoryName("默认分类");
                blogCategory.setCategoryIcon("/admin/dist/img/category/00.png");
            }
            //分类信息
            blogDetailVO.setBlogCategoryIcon(blogCategory.getCategoryIcon());
            if (!StringUtils.isEmpty(blog.getBlogTags())) {
                //标签设置
                List<String> tags = Arrays.asList(blog.getBlogTags().split(","));
                blogDetailVO.setBlogTags(tags);
            }
            return blogDetailVO;
        }
        return null;
    }
```

我们定义了 `getBlogsPageBySearch()` 方法并传入 blogId 参数，该方法的执行逻辑为：

1. **根据 blogId 直接查询 tb_blog 表中的记录**
2. **判断查出的结果是否为空以及文章状态是否为发布状态，不是发布状态返回 null 值**
3. **每次请求文章详情接口都会执行浏览量加一的操作，直接修改 tb_blog 表中的 blog_view 字段**
4. **将 markdown 格式的 content 内容字段转换为带有 html 标签的页面，因为在后台管理系统中操作时使用的是 Editor.md 编辑器，存储到数据库中的字段也是 markdown 格式的字段，在页面中显示的话需要进行转换**
5. **设置分类信息字段**
6. **设置标签字段**
7. **返回结果**

#### markdown 格式转换

在详情页的页面设计中我给出了文章详情页的最终展示效果图，通过 f12 打开浏览器控制台，我们来看一下页面的 html 源码，查看结果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381102396/wm)

通过控制台的页面源码我们可以看出，此时页面上展示的文章内容已经不是 markdown 格式的，而是符合 html 标签语法的代码片段了，但是数据库里的内容确实是 markdown 格式的文档，我们打开数据库来确认一下该字段的值，内容如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381112330/wm)

数据库中存储的内容与页面上显示的内容并不同，也就是说在文章详情请求的过程中，肯定有一个步骤对这个字段进行了转换处理，这一步骤在前文中也已经提到了，接下来我来介绍一下如何将 markdown 格式的 content 内容字段转换为带有 html 标签的页面。

想要达到这个目的，我们需要借助第三方工具类，本系统中我们选择的 markdown 解析器是 CommonMark 解析器，首先需要将相关依赖引入到 pom.xml 文件中，依赖文件增加如下设置：

```
        <!-- commonmark core -->
        <dependency>
            <groupId>com.atlassian.commonmark</groupId>
            <artifactId>commonmark</artifactId>
            <version>0.8.0</version>
        </dependency>
        <!-- commonmark table -->
        <dependency>
            <groupId>com.atlassian.commonmark</groupId>
            <artifactId>commonmark-ext-gfm-tables</artifactId>
            <version>0.8.0</version>
        </dependency>
```

之后我们在 util 包下新建一个 MarkDownUtil 工具类，代码如下：

```
package com.site.blog.my.core.util;
import org.commonmark.Extension;
import org.commonmark.ext.gfm.tables.TablesExtension;
import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.springframework.util.StringUtils;
import java.util.Arrays;

public class MarkDownUtil {
    /**
     * 转换md格式为html
     *
     * @param markdownString
     * @return
     */
    public static String mdToHtml(String markdownString) {
        if (StringUtils.isEmpty(markdownString)) {
            return "";
        }
        java.util.List<Extension> extensions = Arrays.asList(TablesExtension.create());
        Parser parser = Parser.builder().extensions(extensions).build();
        Node document = parser.parse(markdownString);
        HtmlRenderer renderer = HtmlRenderer.builder().extensions(extensions).build();
        String content = renderer.render(document);
        return content;
    }
}
```

这样我们就可以借助 CommonMark 解析器我们将文章的 content 字段由 markdown 格式的字符串转换为页面显示所需的 html 片段。

#### 数据渲染

想要将数据通过 Thymeleaf 语法渲染到前端页面上，首先需要将数据获取并转发到对应的模板页面中，需要在首页请求的 Controller 方法中将查询到的数据放入 request 域中，新增 detail() 方法，代码如下：(**注：完整代码位于 com.site.blog.my.core.controller.blog.MyBlogController.java**)

```
    /**
     * 详情页
     *
     * @return
     */
    @GetMapping("/blog/{blogId}")
    public String detail(HttpServletRequest request, @PathVariable("blogId") Long blogId) {
        BlogDetailVO blogDetailVO = blogService.getBlogDetail(blogId);
        if (blogDetailVO != null) {
            request.setAttribute("blogDetailVO", blogDetailVO);
        }
        request.setAttribute("pageName", "详情");
        return "blog/detail";
    }
```

路径映射为 **/blog/{blogId}**，你也可以根据自己的想法去定义这个路径映射，比如 **/article/{blogId}** 或者 **/detail/{blogId}**, blogId 参数为博客的主键 id 参数，根据它查询出对应的数并放入到 request 对象中，之后跳转到 detail 模板页面进行数据渲染。

新增搜索页 detail.html ，模板代码如下：

```
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="utf-8">
    <title>详情页</title>
    <!-- Bootstrap styles -->
    <link rel="stylesheet" th:href="@{/blog/css/bootstrap.min.css}">
    <!-- Font-Awesome -->
    <link rel="stylesheet" th:href="@{/blog/css/font-awesome/css/font-awesome.min.css}">
    <!-- Styles -->
    <link rel="stylesheet" th:href="@{/blog/css/style.css}" id="theme-styles">
    <!--[if lt IE 9]>
    <script th:src="@{/blog/js/respond.js}"></script>
    <![endif]-->
</head>
<body>
<header>
    <div class="widewrapper masthead">
        <div class="container">
            <a th:href="@{/index}" id="logo">
                <img th:src="@{/blog/img/logo.png}" class="logo-img" alt="my personal blog">
            </a>
            <div id="mobile-nav-toggle" class="pull-right">
                <a href="#" data-toggle="collapse" data-target=".clean-nav .navbar-collapse">
                    <i class="fa fa-bars"></i>
                </a>
            </div>
            <nav class="pull-right clean-nav">
                <div class="collapse navbar-collapse">
                    <ul class="nav nav-pills navbar-nav">
                        <li>
                            <a th:href="@{/index}">主页</a>
                        </li>
                        <li>
                            <a th:href="@{/link}">友链</a>
                        </li>
                        <li>
                            <a th:href="@{/about}">关于</a>
                        </li>
                        <li>
                            <a href="https://github.com/ZHENFENG13">GitHub</a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    </div>
    <div class="widewrapper subheader">
        <div class="container">
            <div class="clean-breadcrumb">
                <img th:src="@{${blogDetailVO.blogCategoryIcon}}" style=" margin-top: -4px;height: 16px;width: 16px;"
                     alt="my personal blog">
                <a href="#">&nbsp;<th:block th:text="${blogDetailVO.blogCategoryName}"></th:block>
                </a>
            </div>
        </div>
    </div>
</header>
<div class="widewrapper main">
    <div class="container">
        <div class="row">
            <div class="col-md-12 blog-main">
                <article class="blog-post">
                    <div class="body" id="blog-content">
                        <h1 th:text="${blogDetailVO.blogTitle}"></h1>
                        <div class="meta">
                            <i class="fa fa-calendar"></i>
                            <th:block th:text="${#dates.format(blogDetailVO.createTime, 'yyyy-MM-dd')}"></th:block>
                            <span class="separator">&#x2F;</span>
                            <i class="fa fa-comments"></i><span class="data"><a
                                href="#comments"><th:block
                                th:text="${blogDetailVO.commentCount}"></th:block>条评论</a></span>
                            <span class="separator">&#x2F;</span>
                            <i class="fa fa-street-view"></i>
                            <th:block th:text="${blogDetailVO.blogViews}"></th:block>
                            浏览
                        </div>
                        <div class="meta">
                            <p class="post-tags">
                                <th:block th:each="tag : ${blogDetailVO.blogTags}">
                                    <a th:href="@{'/tag/' + ${tag}}">
                                        <th:block th:text="${tag}"></th:block>
                                    </a>
                                </th:block>
                            </p>
                        </div>
                        <th:block th:utext="${blogDetailVO.blogContent}"/>
                    </div>
                </article>
                <aside class="blog-rights clearfix">
                    <p>本站文章除注明转载/出处外，皆为作者原创，欢迎转载，但未经作者同意必须保留此段声明，且在文章页面明显位置给出原文连接，否则保留追究法律责任的权利。</p>
                </aside>
                <p class="back-top" id="back-top" style="display:none"><a href="#top"><span></span></a></p>
            </div>
        </div>
    </div>
</div>
<!-- 引入页脚footer-fragment -->
<footer th:replace="blog/footer::footer-fragment"></footer>
<script th:src="@{/blog/js/jquery.min.js}"></script>
<script th:src="@{/blog/js/bootstrap.min.js}"></script>
<script th:src="@{/blog/js/modernizr.js}"></script>
</body>
</html>
```

根据返回的 blogDetail 对象依次将数据渲染到类信息展示区域、文章标题区域、文章的基础信息区域和文章详情区域，使用到的 Thymeleaf 语法也比较简单，直接读取对应的字段即可。

修改完成后重启项目查看数据是否正常，如下图所示在列表中点击不同的博客信息会跳转到对应的详情页面，详情页面中的内容也都正确的显示到页面上，功能一切正常。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381133251/wm)

# 详情页优化

为了提升用户浏览时的使用体验，我也按照其他博客系统的详情页功能增加了一些小工具，总结如下：

#### 小工具 1：代码高亮

技术博客系统的文章详情中肯定少不了代码的出现，在浏览时也经常会看到代码的展示，以咱们常用的开发工具来说，里面也会经常使用一些插件让代码变得五颜六色，可以让代码看起来更直观，也更美观，在网页中我们也可以实现类似的效果。当前开发的博客系统我选择的是 highlight 插件，因为它能够得到上述的代码效果而且比较实用，整合也比较简单。

下载它的相关文件后将其放入到 resources/static/blog/js 目录下，之后在 detail.html 引入它的样式文件和 js 文件：

```
    <!-- highlight -->
    <link rel="stylesheet" th:href="@{/blog/js/highlight/styles/github.css}">

    <script th:src="@{/blog/js/highlight/highlight.pack.js}"></script>
```

之后指定对应 DOM 中的元素进行高亮操作，在 markdown 格式的内容转换为 html 标签格式的内容后，代码块通常是在 `<pre><code>` 中，所以可以进行如下设置：

```
<script type="text/javascript">
    $(function () {
        // 代码高亮
        $('pre code').each(function (i, block) {
            hljs.highlightBlock(block);
        });
    });
</script>
```

**未使用插件时的代码显示如下：**

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381150888/wm)

------

**使用插件后的代码显示如下：**

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381162145/wm)

重启项目再次查看详情页，其中的代码块的样式都已经更改了，视觉效果也会直观一些。在 styles 目录下提供了很多的样式文件，在页面中引入不同的 css 文件代码块也会不同，我试了 default.css、dart.css、github.css，都是比较炫酷的风格，因为 GitHub 的样式平时看的比较多，因此默认就选择了这种风格，如果想要修改的话直接修改引入的 css 文件即可。

#### 小工具 2：返回顶部

下载一个返回顶部的图案，这里是选择了一支小火箭，设置返回顶部按钮的样式和背景图，css 文件如下：

```
.back-top {
    position: fixed;
    bottom: 10px;
    right: 5px;
    z-index: 99;
}

.back-top span {
    width: 50px;
    height: 64px;
    display: block;
    background: url(../img/rocket.png) no-repeat center center;
}

.back-top a {
    outline: none
}
```

监听页面滚动事件，为返回顶部按钮添加监听事件，点击后页面重新回到最顶部，添加如下 js 代码：

```
<script type="text/javascript">
    $(function() {
        $("#back-top").hide();
        $(window).scroll(function() {
            if ($(this).scrollTop() > 300) {
                $('#back-top').fadeIn();
            } else {
                $('#back-top').fadeOut();
            }
        });
        // scroll body to 0px on click
        $('#back-top a').click(function() {
            $('body,html').animate({
                scrollTop: 0
            }, 800);
            return false;
        });
    });
</script>
```

重启项目并测试，效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381178613/wm)

#### 小工具 3：目录生成

将目录生成的方法放入到 resources/static/blog/js 目录下，之后在 detail.html 引入它的样式文件和 js 文件：

```
    <!-- dictionary -->
    <link rel="stylesheet" th:href="@{/blog/js/dictionary/dictionary.css}">    

    <script th:src="@{/blog/js/dictionary/dictionary.js}"></script>
```

页面加载完成后，初始化 createBlogDirectory() 方法：

```
    $(function () {
        //创建博客目录
        createBlogDirectory("blog-content", "h2", "h3", 20);
    })
```

这样就可以生成文章的目录结构了，但是前提是文章中含有 h2 和 h3 标签，markdown 编辑器中的写法为：

```
## 二级标题

### 三级标题
```

重启查看效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381203481/wm)

至此，文章详情页的访问和渲染以及页面小工具的添加都完成了。

# 总结

本实验主要讲解了文章详情页的设计以及功能实现，之后又讲解了几个小工具主要目的也是为了用户在查看文章时能够方便一些，还有一个内容是文章评论，因为该模块中的功能比较多所以就单独拿出一个实验来讲解和介绍了。

本节实验到此结束，同学们可以按照文中的思路和过程自行测试。