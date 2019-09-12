# 实验介绍

#### 实验内容

前一个实验中主要介绍了文章编辑器 Editor.md 的整合和使用，一个易用、合适的编辑器对于博客系统来说是非常重要的，尤其是对于一个开源在 GitHub 上的博客系统，因为会有世界各地的 Java 开发者可能会用到它，如果连最基础的编辑器都没有整合完善的话，这个博客系统的生命周期肯定很低，因此花费了一个章节来介绍和实际的整合。文章模块肯定不止编辑器的整合，包括文章表也不止一个内容字段，接下去的实验我们会对文章模块进行分析并作出表结构设计，之后进行编辑页面的制作和功能开发。

#### 实验知识点

- 博客文章模块表结构设计
- 文章编辑页面制作
- 文章添加功能实现

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-22.zip
unzip My-Blog-22.zip
cd My-Blog
```

# 博客文章模块简介

**博客** (blog) 一词源于 Web Log (网络日志)的缩写，是一种十分简单的个人信息发布方式，任何人都可以快速完成个人网页的创建、发布和更新。博客就是开放的私人空间，可以充分利用超文本链接、网络互动、动态更新等特点在网络中，精选并链接全球互联网中最有价值的信息、知识与资源，也可以将个人工作过程、生活故事、思想历程、闪现的灵感等及时记录和发布，发挥个人无限的表达力。

写博客的目的是为了记录以及分享，相较于当前流行的传输媒介来说，博客这种媒介形式可以说是历史悠久了，目前已经很少有人使用这种形式来记录和分享自己的日常，现在新的媒介层出不穷，微博、朋友圈、抖音等更符合大部分人的需求，博客这种形式已经日渐式微，写博客这个事情貌似只在互联网从业人员中还有一定的地位，开发人员也比较喜欢使用这种形式去分享和记录自己的知识和经历，对于大部分开发者来说，有一个自己的博客可以发出自己的声音也是一件十分令人兴奋的事情，这种博客暂且把它叫做技术博客吧，我们这次实践开发的项目也是技术博客系统的搭建。

这里简单的列举几个开发者使用频繁的几个博客平台：

- [CSDN](https://www.csdn.net/)
- [博客园](https://www.cnblogs.com/)
- [简书](http://www.jianshu.com/)

当然还有其他一些博客网站，这里我就不一一列举了，大家可以去看一下各个博客平台的文章详情页，不论博客这种形式已经出现了多少年，亦或者是不同的博客平台，博客这种表现形式的底层依然是文章，每一篇博客其实都是文章，文章中包括文章标题、文章内容，这两块儿是必不可少的，其他的内容可能因为平台之间的差异而有细微的不同。

# 表结构设计及 Mapper 文件自动生成

#### 表结构设计

这里以 CSDN 平台的文章编辑模块为例，我们来确定一下文章表的字段设计，编辑模块如下图所示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379650328/wm)

通过上图我们可以得出以下字段：

- 文章标题
- 文章内容
- 文章标签
- 文章分类
- 发布状态

以上是字段是博客文章实体应该具有的基础字段，不管是哪个博客平台都会存在这些字段，我们的博客系统上在此基础上增加了几个字段：

- 文章封面图(为了页面美观)
- 阅读量(博客文章的基本字段)
- 是否允许评论(有评论模块，可以控制评论模块的开放和关闭)

文章表的 SQL 设计如下，直接执行如下 SQL 语句即可：

```
USE `my_blog_db`;

DROP TABLE IF EXISTS `tb_blog`;

CREATE TABLE `tb_blog` (
  `blog_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '博客表主键id',
  `blog_title` varchar(200) NOT NULL COMMENT '博客标题',
  `blog_sub_url` varchar(200) NOT NULL COMMENT '博客自定义路径url',
  `blog_cover_image` varchar(200) NOT NULL COMMENT '博客封面图',
  `blog_content` mediumtext NOT NULL COMMENT '博客内容',
  `blog_category_id` int(11) NOT NULL COMMENT '博客分类id',
  `blog_category_name` varchar(50) NOT NULL COMMENT '博客分类(冗余字段)',
  `blog_tags` varchar(200) NOT NULL COMMENT '博客标签',
  `blog_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-草稿 1-发布',
  `blog_views` bigint(20) NOT NULL DEFAULT '0' COMMENT '阅读量',
  `enable_comment` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-允许评论 1-不允许评论',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否删除 0=否 1=是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`blog_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

# MyBatis-Generator 插件自动生成 Mapper 文件

首先，我们使用 MyBatis-Generator 插件将该表对应的 Mapper 文件及对应的实体类和 Dao 层接口生成出来，这部分代码就不贴在文章中了，大家可以通过下载源码来查看。

需要注意的是，在代码生成后需要在 dao 层下的 BlogMapper 接口类上添加 `@Mapper` 注解以将其注册到 IOC 容器中以供后续调用（如果已经在主类上添加 `@MapperScan` 注解这一步可以省略）。其次，在 tb_blog 表中，我们设计了一个 is_deleted 字段，用于逻辑删除的标志位，由于 is_deleted 的字段设计，我们对表中数据的删除都是软删除，因为是个人博客，这么做的目的主要也是为了防止误删，因此我们需要修改 Mapper 文件中的 查询语句和删除语句，将 is_deleted 条件带上，修改后的语句如下：(**注：完整代码位于 resources/mapper/BlogMapper.xml**)

```
    <select id="selectByPrimaryKey" parameterType="java.lang.Long" resultMap="ResultMapWithBLOBs">
        select
        <include refid="Base_Column_List"/>
        ,
        <include refid="Blob_Column_List"/>
        from tb_blog
        where blog_id = #{blogId,jdbcType=BIGINT} and is_deleted = 0
    </select>

    <update id="deleteByPrimaryKey" parameterType="java.lang.Long">
    UPDATE tb_blog SET is_deleted = 1
    where blog_id = #{blogId,jdbcType=BIGINT} and is_deleted = 0
  </update>
```

通过以上代码我们可以看出，在删除操作时我们并不是执行 delete 语句，而是将需要删除的文章记录的 is_deleted 字段修改为 1，这样就表示该文章已经被执行了删除操作，那么其他的 select 查询语句就需要在查询条件中添加 is_deleted = 0 将“被删除”的记录给过滤出去。

# 编辑页面完善

接下来，把编辑页面按照字段来完善一下，以前文中 CSDN 平台的文章编辑页面为例，将其他需要输入内容的字段填充到页面 DOM 中，目前编辑页面只有一个编辑框来输入文章字段。某些字段只需要一个 input 框即可，比如文章标题字段，而其他一些字段的输入则需要一些前端插件来完成，比如标签、博客封面图，仅仅是 input 框肯定是无法满足需求的，比如标签字段和分类字段，我们想要的最终效果是下面这样的：

- 标签字段输入

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379673523/wm)

- 分类选择

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379687662/wm)

接下来我们把文章编辑页面完善一下，同时也把这些小插件整合进来。

#### 引入相关依赖

编辑页面中有如下字段需要使用插件来完善交互：

- 标签字段
- 分类字段
- 文章内容字段(已实现)
- 封面图字段

以上字段所需要的插件也是使用的比较常用的开源插件，插件如下：

- tagsinput（标签）
- select2（分类）
- Editor.md（文章内容）
- ajaxupload（图片上传）

引入插件首先需要把这些依赖文件放到 resources/static/admin/plugins 目录下，目录结构如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379705428/wm)

之后在 edit.html 文件中引到页面中，代码如下：(**注：完整代码位于 resources/templates/admin/edit.html**)

- CSS 文件

```
<link th:href="@{/admin/plugins/editormd/css/editormd.css}" rel="stylesheet"/>
<link th:href="@{/admin/plugins/tagsinput/jquery.tagsinput.css}" rel="stylesheet"/>
<link th:href="@{/admin/plugins/select2/select2.css}" rel="stylesheet"/>
```

- JS 文件

```
<!-- editor.md -->
<script th:src="@{/admin/plugins/editormd/editormd.min.js}"></script>
<!-- tagsinput -->
<script th:src="@{/admin/plugins/tagsinput/jquery.tagsinput.min.js}"></script>
<!-- Select2 -->
<script th:src="@{/admin/plugins/select2/select2.full.min.js}"></script>
<!-- ajaxupload -->
<script th:src="@{/admin/plugins/ajaxupload/ajaxupload.js}"></script>
```

#### 编辑页面代码

根据字段新增对应的输入框以及 DOM 组件，代码如下：

```
<div class="card-body">
    <!-- 几个基础的输入框，名称、分类等输入框 -->
    <form id="blogForm" onsubmit="return false;">
        <div class="form-group" style="display:flex;">
            <input type="text" class="form-control col-sm-6" id="blogName" name="blogName"
                   placeholder="*请输入文章标题(必填)">
            &nbsp;&nbsp;
            <input type="text" class="form-control" id="blogTags" name="blogTags"
                   placeholder="请输入文章标签"
                   style="width: 100%;">
        </div>
        <div class="form-group" style="display:flex;">
            <input type="text" class="form-control col-sm-6" id="blogSubUrl"
                   name="blogSubUrl"
                   placeholder="请输入自定义路径,如:springboot-mybatis,默认为id"> &nbsp;&nbsp;
            <select class="form-control select2" style="width: 100%;" id="blogCategoryId"
                    data-placeholder="请选择分类...">
                <th:block th:if="${null == categories}">
                    <option value="0" selected="selected">默认分类</option>
                </th:block>
                <th:block th:unless="${null == categories}">
                    <th:block th:each="c : ${categories}">
                        <option th:value="${c.categoryId}" th:text="${c.categoryName}">

                        </option>
                    </th:block>
                </th:block>
            </select>
        </div>
        <div class="form-group" id="blog-editormd">
            <textarea style="display:none;"></textarea>
        </div>
        <div class="form-group">
            <div class="col-sm-4">
                <img id="blogCoverImage" src="/admin/dist/img/img-upload.png"
                     style="height: 64px;width: 64px;">
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
                   value="1"/>&nbsp;发布&nbsp;
            <input name="blogStatus" type="radio" id="draft" value="0"/>&nbsp;草稿&nbsp;&nbsp;&nbsp;
            <label class="control-label">是否允许评论:&nbsp;</label>
            <input name="enableComment" type="radio" id="enableCommentTrue" checked=true
                   value="0"/>&nbsp;是&nbsp;
            <input name="enableComment" type="radio" id="enableCommentFalse" value="1"/>&nbsp;否&nbsp;
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
</div>
```

其中文章标题字段和自定义路径字段是直接使用的 input 框，标签字段会使用 tagsinput 插件，分类字段会使用 select2 下来选择框插件，博客封面图则是使用图片上传插件，文章内容的输入使用的是 Editor.md 编辑器，文章状态字段和评论开关字段使用的是 radio 选择框，最下面是两个功能按钮，文章保存和返回按钮。

#### 初始化插件

在 resources/static/admin/dist/js 目录下新增 edit.js 文件，把原来在 edit.html 文件中写的 Editor.md 初始化 js 代码也移到 edit.js 文件中，并添加如下代码：

```
var blogEditor;
// Tags Input
$('#blogTags').tagsInput({
    width: '100%',
    height: '38px',
    defaultText: '文章标签'
});

//Initialize Select2 Elements
$('.select2').select2()

$(function () {
    blogEditor = editormd("blog-editormd", {
        width: "100%",
        height: 640,
        syncScrolling: "single",
        path: "/admin/plugins/editormd/lib/",
        toolbarModes: 'full',
        /**图片上传配置*/
        imageUpload: true,
        imageFormats: ["jpg", "jpeg", "gif", "png", "bmp", "webp"], //图片上传格式
        imageUploadURL: "/admin/blogs/md/uploadfile",
        onload: function (obj) { //上传成功之后的回调
        }
    });

    new AjaxUpload('#uploadCoverImage', {
        action: '/admin/upload/file',
        name: 'file',
        autoSubmit: true,
        responseType: "json",
        onSubmit: function (file, extension) {
            if (!(extension && /^(jpg|jpeg|png|gif)$/.test(extension.toLowerCase()))) {
                alert('只支持jpg、png、gif格式的文件！');
                return false;
            }
        },
        onComplete: function (file, r) {
            if (r != null && r.resultCode == 200) {
                $("#blogCoverImage").attr("src", r.data);
                $("#blogCoverImage").attr("style", "width: 128px;height: 128px;display:block;");
                return false;
            } else {
                alert("error");
            }
        }
    });
});

/**
 * 随机封面功能
 */
$('#randomCoverImage').click(function () {
    var rand = parseInt(Math.random() * 40 + 1);
    $("#blogCoverImage").attr("src", '/admin/dist/img/rand/' + rand + ".jpg");
    $("#blogCoverImage").attr("style", "width:160px ;height: 120px;display:block;");
});
```

以上代码中初始化了四个字段的页面 DOM 属性，分别是标签、分类、编辑框、图片上传框，其中文章内容编辑框在前一个实验中已经讲解，图片上传的功能在 **实验 6：Spring Boot 处理文件上传及路径回显** 也已经讲解，这里就不再浪费篇幅，有问题的同学可以直接看前面的实验进行复习，标签和分类的初始化就是直接调用他们的初始化方法即可。

#### 页面预览

至此，博客编辑页面的前端开发就完成了大半，重启项目看一下预览效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379726499/wm)

页面看起来复杂，交互也复杂，甚至可以说这个页面整合了一个编辑页面该有的全部元素，你可以自行拿本页面与其他接触到项目中的编辑页面进行比较，各种插件和功能也都有使用到。虽然复杂，同学们也不用担心，再复杂它也是一点点整合起来的、也是一个个知识点拼起来的，我已经将这些知识点进行了拆解并在不同的实验中讲解和演示，希望大家能够跟着十三的思路把这些知识点进行拆解和整合，这样就能够更好的理解了。

# 文章添加功能实现

#### 文章添加接口

添加接口负责接收前端的 POST 请求并处理其中的参数，接收的参数为用户在博客编辑页面输入的所有字段内容，字段名称与对应的含义如下：

1. "**blogTitle**": 文章标题
2. "**blogSubUrl**": 自定义路径
3. "**blogCategoryId**": 分类 id (下拉框中选择)
4. "**blogTags**": 标签字段(以逗号分隔)
5. "**blogContent**": 文章内容(编辑器中的 md 文档)
6. "**blogCoverImage**": 封面图(上传图片或者随机图片的路径)
7. "**blogStatus**": 文章状态
8. "**enableComment**": 评论开关

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.BlogController.java**）

在 BlogController 中新增 save() 方法，接口的映射地址为 /blogs/save，请求方法为 POST，代码如下：

```
    @PostMapping("/blogs/save")
    @ResponseBody
    public Result save(@RequestParam("blogTitle") String blogTitle,
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
        blog.setBlogTitle(blogTitle);
        blog.setBlogSubUrl(blogSubUrl);
        blog.setBlogCategoryId(blogCategoryId);
        blog.setBlogTags(blogTags);
        blog.setBlogContent(blogContent);
        blog.setBlogCoverImage(blogCoverImage);
        blog.setBlogStatus(blogStatus);
        blog.setEnableComment(enableComment);
        String saveBlogResult = blogService.saveBlog(blog);
        if ("success".equals(saveBlogResult)) {
            return ResultGenerator.genSuccessResult("添加成功");
        } else {
            return ResultGenerator.genFailResult(saveBlogResult);
        }
    }
```

添加接口中，首先会对参数进行校验，之后交给业务层代码进行操作。

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.BlogServiceImpl.java**）

在 service 包中新建 BlogService 并定义接口方法 `saveBlog()`，下面为具体的实现方法代码：

```
@Service
public class BlogServiceImpl implements BlogService {

    @Autowired
    private BlogMapper blogMapper;
    @Autowired
    private BlogCategoryMapper categoryMapper;
    @Autowired
    private BlogTagMapper tagMapper;
    @Autowired
    private BlogTagRelationMapper blogTagRelationMapper;

    @Override
    @Transactional//开启事务
    public String saveBlog(Blog blog) {
        BlogCategory blogCategory = categoryMapper.selectByPrimaryKey(blog.getBlogCategoryId());
        if (blogCategory == null) {
            blog.setBlogCategoryId(0);
            blog.setBlogCategoryName("默认分类");
        } else {
            //设置博客分类名称
            blog.setBlogCategoryName(blogCategory.getCategoryName());
            //分类的排序值加1
            blogCategory.setCategoryRank(blogCategory.getCategoryRank() + 1);
        }
        //处理标签数据
        String[] tags = blog.getBlogTags().split(",");
        if (tags.length > 6) {
            return "标签数量限制为6";
        }
        //保存文章
        if (blogMapper.insertSelective(blog) > 0) {
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
            //新增标签数据并修改分类排序值
            if (!CollectionUtils.isEmpty(tagListForInsert)) {
                tagMapper.batchInsertBlogTag(tagListForInsert);
            }
            categoryMapper.updateByPrimaryKeySelective(blogCategory);
            List<BlogTagRelation> blogTagRelations = new ArrayList<>();
            //新增关系数据
            allTagsList.addAll(tagListForInsert);
            for (BlogTag tag : allTagsList) {
                BlogTagRelation blogTagRelation = new BlogTagRelation();
                blogTagRelation.setBlogId(blog.getBlogId());
                blogTagRelation.setTagId(tag.getTagId());
                blogTagRelations.add(blogTagRelation);
            }
            if (blogTagRelationMapper.batchInsert(blogTagRelations) > 0) {
                return "success";
            }
        }
        return "保存失败";
    }
}
```

文章实体的新增与前文中的新增方法比较起来是略微复杂了一些，因为前面的都是单表操作，并不涉及关系表的操作，而文章表由于与分类表、标签表有关联关系，因此在新增文章内容时需要对其它表进行查询和修改操作，对于分类表只是查询和验证，对于标签表则需要查询和新增操作，因为标签是在文章编辑页面输入的，如果某些标签内容是标签表中没有的则需要新增，之后会操作文章标签关系表，将文章与标签关联起来并新增至关系表中，相关逻辑已经在以上代码中，关键注释也已经给出。

- 关键 SQL

根据标签名称查询标签以及批量新增标签 （注：完整代码位于 **resources/mapper/BlogTagMapper.xml**）

```
    <select id="selectByTagName" parameterType="java.lang.String" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog_tag
        where tag_name = #{tagName,jdbcType=VARCHAR} AND is_deleted = 0
    </select>

   <insert id="batchInsertBlogTag" parameterType="java.util.List" useGeneratedKeys="true"
            keyProperty="tagId">
        INSERT into tb_blog_tag(tag_name)
        VALUES
        <foreach collection="list" item="item" separator=",">
            (#{item.tagName,jdbcType=VARCHAR})
        </foreach>
    </insert>
```

批量新增文章标签关系数据（注：完整代码位于 **resources/mapper/BlogTagRelationMapper.xml**）

```
    <insert id="batchInsert" parameterType="java.util.List">
        INSERT into tb_blog_tag_relation(blog_id,tag_id)
        VALUES
        <foreach collection="relationList" item="item" separator=",">
            (#{item.blogId,jdbcType=BIGINT},#{item.tagId,jdbcType=INTEGER})
        </foreach>
    </insert>
```

以上都是本次实验新增的 DAO 方法，并不是自动生成的代码。

#### Ajax 调用添加接口

在信息录入完成后可以点击信息编辑框下方的**保存文章**按钮，此时会调用后端接口并进行数据的交互，js 实现代码如下：(**注：完整代码位于 resources/static/admin/dist/js/edit.js**)

```
$('#confirmButton').click(function () {
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
    var data = {
        "blogTitle": blogTitle, "blogSubUrl": blogSubUrl, "blogCategoryId": blogCategoryId,
        "blogTags": blogTags, "blogContent": blogContent, "blogCoverImage": blogCoverImage, "blogStatus": blogStatus,
        "enableComment": enableComment
    };
    console.log(data);
    $.ajax({
        type: 'POST',//方法类型
        url: url,
        data: data,
        success: function (result) {
            if (result.resultCode == 200) {
                swal("保存成功", {
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

首先绑定 `#confirmButton` 的点击事件，点击后会获取所有的输入内容并进行验证，之后封装数据并向后端发送 Ajax 请求添加文章。

# 功能验证

我们提供了本实验所需的完整代码，请大家下载并参照源码对比学习了解各个功能模块的代码内容。

# 启动 MySQL 并新增 tb_blog 表

详细步骤可以参考实验 15 中的内容，启动 MySQL 服务并登陆，之后将建表语句执行即可。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379756993/wm)

# 启动项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到已解压的 My-Blog 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 mvn spring-boot:run ，之后就可以等待项目启动。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379768770/wm)

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果，之后会在浏览器中弹出 `https://********.simplelab.cn` 访问页面：`https://********.simplelab.cn/admin/login` 登陆至后台管理首页，之后点击发布博客就可以对相关功能进行测试了，演示过程如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379780218/wm)

主要是为了保存文章到数据库，但是在测试过程中，我们也对编辑器中的图片上传和封面图上传进行了测试，点击保存后提示保存成功，功能一切正常。

#### 验证

虽然提示保存成功了，我们依然需要验证一次 MySQL 中是否有数据，直接查询 tb_blog 表中的记录即可：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379793399/wm)

演示过程中上传的图片也都在 upload 目录下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564379803635/wm)

验证通过！同学们可以按照文中的思路和过程自行测试，本次实验完成！

# 总结

总结了以下几点注意事项，大家留心一些。

- 由于本次实验中的内容比较复杂、知识点的整合较多，建议大家多联系前面一些实验中的知识点进行理解和学习，如果有不理解的地方，就先把知识点拆解，先学会单个知识点，之后再进行整合，这样会事半功倍。
- 由于本实验较复杂所以代码也比较多，并没有把所有的代码都贴出来，我挑选了一些比较重要的关键代码放在文中，同学们可以下载本实验完整的源码来学习。
- 编码完成，进行测试的时候需要注意两点，一是文章数据是否被插入到数据库表中，二是图片有没有正确上传，因为封面图上传时使用到了图片上传功能，默认上传路径为 **/home/project/upload/** ，功能测试前先检查是否创建了该目录（此目录可根据部署情况自行修改），之后验证图片上传是否正常。

后续我们继续来完善文章模块的页面、交互逻辑以及后端功能。