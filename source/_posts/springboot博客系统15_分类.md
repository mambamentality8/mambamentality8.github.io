# 实验介绍

#### 实验内容

前文已经实现了用户的登陆及权限验证模块，接下来将会继续完善后台功能，开发博客系统的文章相关模块，本节实验将会对博客的分类模块进行介绍和功能开发及完善。

#### 实验知识点

- 分类模块介绍
- 分类模块表结构设计及接口实现
- 分类模块页面设计及编码
- 分类功能测试

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 1.4 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-19.zip
unzip My-Blog-19.zip
cd My-Blog
```

# 分类模块简介

在博客系统中，分类模块的设计是不可缺少的，我们在各大博客网站中都能够看到这个模块设计，在浏览文章的过程中，我们也会挑选出我们感兴趣类别中的文章进行阅读，比如看了一篇架构的文章，觉得不错，那么就想接着去看这个类别下的其他文章，或者你偏爱前端类别下的内容，那就可以针对性的浏览所有前端类别下的文章，因此对博文进行归类是十分必要的。

分类是通过比较事物之间的相似性，把具有某些共同点或相似特征的事物归属于一个不确定集合的逻辑方法，而对应的，我们可以说分类别的作用是使一个大集合中的内容条理清楚，层次分明，接下来是功能开发的讲解。

# 表结构设计及 Mapper 文件自动生成

#### 表结构设计

在进行接口设计和具体的功能实现前，首先将表结构确定下来，每篇文章都会被归类到一个类别下，一个类别下会有多篇文章，分类实体与文章实体的关系是一对多的关系，因此在表结构设计时，在文章表中设置一个分类关联字段即可，分类表只需要将分类相关的字段定义好，分类实体与文章实体的关系交给文章表来维护即可（后续讲到文章表时再介绍），分类表的 SQL 设计如下，直接执行如下 SQL 语句即可：

```
USE `my_blog_db`;

/*Table structure for table `tb_blog_category` */

CREATE TABLE `tb_blog_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类表主键',
  `category_name` varchar(50) NOT NULL COMMENT '分类的名称',
  `category_icon` varchar(50) NOT NULL COMMENT '分类的图标',
  `category_rank` int(11) NOT NULL DEFAULT '1' COMMENT '分类的排序值 被使用的越多数值越大',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否删除 0=否 1=是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

分类表的字段以及每个字段对应的含义都在上面的 SQL 中有介绍，大家可以对照 SQL 进行理解，把表结构导入到数据库中即可，接下来我们进行编码工作。

# MyBatis-Generator 插件自动生成 Mapper 文件

首先，我们使用 MyBatis-Generator 插件将该表对应的 Mapper 文件及对应的实体类和 Dao 层接口生成出来，这部分代码就不贴在文章中了，大家可以通过下载源码来查看。

需要注意的是，在代码生成后需要在 dao 层下的 BlogCategoryMapper 接口类上添加 @Mapper 注解以将其注册到 IOC 容器中以供后续调用（如果已经在主类上添加 @MapperScan 注解这一步可以省略）。其次，在 tb_blog_category 表中，我们设计了一个 is_deleted 字段，用于逻辑删除的标志位，由于 is_deleted 的字段设计，我们对表中数据的删除都是软删除，而不是真正意义的删除，只是做了一个删除标志位，如果此字段为 1 则表示已经被删除不再使用，因为是个人博客，这么做的目的主要也是为了防止误删，因此我们需要修改 Mapper 文件中的 查询语句和删除语句，将 is_deleted 条件带上，修改后的语句如下：(**注：完整代码位于 resources/mapper/BlogCategoryMapper.xml**)

```
   <select id="findCategoryList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog_category
        where is_deleted=0
        order by category_rank desc,create_time desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalCategories" parameterType="Map" resultType="int">
    select count(*)  from tb_blog_category
    where is_deleted=0
    </select>

    <select id="selectByPrimaryKey" parameterType="java.lang.Integer" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog_category
        where category_id = #{categoryId,jdbcType=INTEGER} AND is_deleted = 0
    </select>

    <update id="deleteByPrimaryKey" parameterType="java.lang.Integer">
    UPDATE tb_blog_category SET  is_deleted = 1
    where category_id = #{categoryId,jdbcType=VARCHAR} AND is_deleted = 0
    </update>
```

通过以上代码我们可以看出，在删除操作时我们并不是执行 delete 语句，而是将需要删除的这条记录的 is_deleted 字段修改为 1，这样就表示该行记录已经被执行了删除操作，那么其他的 select 查询语句就需要在查询条件中添加 `is_deleted = 0` 将“被删除”的记录给过滤出去，这个知识点希望大家能够理解，在后续的其他功能模块中我们也会使用软删除的设计。

# 分类模块接口设计及实现

#### 接口介绍

为了让页面体验更加友好，就不采用传统的 MVC 跳转模式，一个功能一个页面，这种交互感觉有些浪费，翻页的时候，翻一页跳转一次也比较繁琐，添加或者新增的时候也要进行页面跳转，所以这些功能的实现就采用通过 Ajax 异步与后端交互数据，当使用者点击了页面上的元素，此时触发响应的 js 事件，进而通过 Ajax 的方式向后端请求数据，前端再根据后端返回的数据内容去进行响应的展示逻辑，在前面的个人信息修改中其实用到的就是这种方式。

关于接口的设计以及前后端交互数据的设计大家可以参考一下第 10 课中的内容，分类模块在后台管理系统中有 5 个接口，分别是：

- 分类列表分页接口
- 添加分类接口
- 根据 id 获取单条分类记录接口
- 修改分类接口
- 删除分类接口

接下来讲解每个接口具体的实现代码，首先在 controller/admin 包下新建 CategoryController.java，并在 service 包下新建业务层代码 CategoryService.java 及实现类，之后参照接口分别进行功能实现。

# 分类列表分页接口

列表接口负责接收前端传来的分页参数，如 `page` 、`limit` 等参数，之后将数据总数和对应页面的数据列表查询出来并封装为分页数据返回给前端。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.CategoryController.java**）：

接口的映射地址为 /categories/list，请求方法为 GET，代码如下：

```
    /**
     * 分类列表
     */
    @RequestMapping(value = "/categories/list", method = RequestMethod.GET)
    @ResponseBody
    public Result list(@RequestParam Map<String, Object> params) {
        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        PageQueryUtil pageUtil = new PageQueryUtil(params);
        return ResultGenerator.genSuccessResult(categoryService.getBlogCategoryPage(pageUtil));
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.CategoryServiceImpl.java**）：

```
    public PageResult getBlogCategoryPage(PageQueryUtil pageUtil) {
        List<BlogCategory> categoryList = blogCategoryMapper.findCategoryList(pageUtil);
        int total = blogCategoryMapper.getTotalCategories(pageUtil);
        PageResult pageResult = new PageResult(categoryList, total, pageUtil.getLimit(), pageUtil.getPage());
        return pageResult;
    }
```

- BlogCategoryMapper.xml （注：完整代码位于 **resources/mapper/BlogCategoryMapper.xml**）：

```
    <select id="findCategoryList" parameterType="Map" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from tb_blog_category
        where is_deleted=0
        order by category_rank desc,create_time desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <select id="getTotalCategories" parameterType="Map" resultType="int">
    select count(*)  from tb_blog_category
    where is_deleted=0
    </select>
```

SQL 语句在 BlogCategoryMapper.xml 文件中，一般的分页也就是使用 limit 关键字实现，获取响应条数的记录和总数之后再进行数据封装，这个接口就是根据前端传的分页参数进行查询并返回分页数据以供前端页面进行数据渲染。

# 添加分类接口

添加接口负责接收前端的 POST 请求并处理其中的参数，接收的参数为 categoryName 字段和 categoryIcon 字段，categoryName 为分类名称，categoryIcon 字段为分类的图标字段。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.CategoryController.java**）：

接口的映射地址为 /categories/save，请求方法为 POST，代码如下：

```
    /**
     * 分类添加
     */
    @RequestMapping(value = "/categories/save", method = RequestMethod.POST)
    @ResponseBody
    public Result save(@RequestParam("categoryName") String categoryName,
                       @RequestParam("categoryIcon") String categoryIcon) {
        if (StringUtils.isEmpty(categoryName)) {
            return ResultGenerator.genFailResult("请输入分类名称！");
        }
        if (StringUtils.isEmpty(categoryIcon)) {
            return ResultGenerator.genFailResult("请选择分类图标！");
        }
        if (categoryService.saveCategory(categoryName, categoryIcon)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("分类名称重复");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.CategoryServiceImpl.java**）：

```
    public Boolean saveCategory(String categoryName, String categoryIcon) {
        BlogCategory temp = blogCategoryMapper.selectByCategoryName(categoryName);
        if (temp == null) {
            BlogCategory blogCategory = new BlogCategory();
            blogCategory.setCategoryName(categoryName);
            blogCategory.setCategoryIcon(categoryIcon);
            return blogCategoryMapper.insertSelective(blogCategory) > 0;
        }
        return false;
    }
```

SQL 语句在 BlogCategoryMapper.xml 文件中，是自动生成的 SQL，这里就不贴了。

添加接口中，首先会对参数进行校验，之后交给业务层代码进行操作，在 `saveCategory()` 方法中，首先会根据名称查询是否已经存在该分类，之后才会进行数据封装并进行数据库 insert 操作。

# 删除分类接口

删除接口负责接收前端的分类删除请求，处理前端传输过来的数据后，将这些记录从数据库中删除，这里的“删除”功能并不是真正意义上的删除，而是逻辑删除，我们将接受的参数设置为一个数组，可以同时删除多条记录，只需要在前端将用户选择的记录 id 封装好再传参到后端即可。

- 控制层代码（注：完整代码位于 **com.site.blog.my.core.controller.admin.CategoryController.java**）：

接口的映射地址为 /categories/delete，请求方法为 POST，代码如下：

```
     /**
     * 分类删除
     */
    @RequestMapping(value = "/categories/delete", method = RequestMethod.POST)
    @ResponseBody
    public Result delete(@RequestBody Integer[] ids) {
        if (ids.length < 1) {
            return ResultGenerator.genFailResult("参数异常！");
        }
        if (categoryService.deleteBatch(ids)) {
            return ResultGenerator.genSuccessResult();
        } else {
            return ResultGenerator.genFailResult("删除失败");
        }
    }
```

- 业务层代码（注：完整代码位于 **com.site.blog.my.core.service.impl.CategoryServiceImpl.java**）：

```
    public Boolean deleteBatch(Integer[] ids) {
        if (ids.length < 1) {
            return false;
        }
        //删除分类数据
        return blogCategoryMapper.deleteBatch(ids) > 0;
    }
```

- BlogCategoryMapper.xml （注：完整代码位于 **resources/mapper/BlogCategoryMapper.xml**）：

```
    <update id="deleteBatch">
        update tb_blog_category
        set is_deleted=1 where category_id in
        <foreach item="id" collection="array" open="(" separator="," close=")">
            #{id}
        </foreach>
    </update>
```

接口的请求路径为 /categories/delete，并使用 `@RequestBody` 将前端传过来的参数封装为 id 数组，参数验证通过后则调用 `deleteBatch()` 批量删除方法进行数据库操作，否则将向前端返回错误信息。

# 其它

还有根据 id 获取详情的接口，路径为 categories/info/{id}，请求方法为 GET；分类修改接口，路径为 categories/update，请求方法为 POST。

在接口设计和实现完成后，需要对接口进行测试，如果出现问题立刻修复，以上这些代码我都已经编写完成并将代码以压缩包的形式提供，大家在学习时可以直接使用我给的代码进行练习。

# 前端页面实现

#### category.html

在 resources/templates/admin 目录下新建 category.html，并引入对应的 js 文件和 css 样式文件。

#### 功能按钮

分类管理模块我们也设计了常用的几个功能：分类信息增加、分类信息编辑、分类信息删除，因此在页面中添加对应的功能按钮以及触发事件，代码如下：

```
<div class="grid-btn">
    <button class="btn btn-info" onclick="categoryAdd()"><i class="fa fa-plus"></i>&nbsp;新增
    </button>
    <button class="btn btn-info" onclick="categoryEdit()"><i class="fa fa-pencil-square-o"></i>&nbsp;修改</button>
    <button class="btn btn-danger" onclick="deleteCagegory()"><i class="fa fa-trash-o"></i>&nbsp;删除</button>
</div>
```

分别是添加按钮，对应的触发事件是 `categoryAdd()` 方法，修改按钮，对应的触发事件是 `categoryEdit()` 方法，删除按钮，对应的触发事件是 `deleteCagegory()` 方法，这些方法我们将在后续的代码实现中给出。

#### 分页信息展示区域

页面中已经引入 JqGrid 的相关静态资源文件，需要在页面中展示分页数据的区域增加如下代码：

```
<table id="jqGrid" class="table table-bordered"></table>
<div id="jqGridPager"></div>
```

#### 页面效果

那么最终的静态页面效果展示如下图所示：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378788819/wm)

包括功能按钮、数据列表展示区域以及翻页功能区域，此时只是静态效果展示，并没有与后端进行数据交互，接下来我们将结合 Ajax 和后端接口实现具体的功能。

# 分类模块前端功能实现

完成了页面展示的实现，接着完成相关的功能实现。请大家一定自行对照源码完成代码编写。

# 分页功能

在 resources/static/admin/dist/js 目录下新增 category.js 文件，并添加如下代码：

```
$(function () {
    $("#jqGrid").jqGrid({
        url: '/admin/categories/list',
        datatype: "json",
        colModel: [
            {label: 'id', name: 'categoryId', index: 'categoryId', width: 50, key: true, hidden: true},
            {label: '分类名称', name: 'categoryName', index: 'categoryName', width: 240},
            {label: '分类图标', name: 'categoryIcon', index: 'categoryIcon', width: 120, formatter: imgFormatter},
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

以上代码的主要功能为分页数据展示、字段格式化 jqGrid DOM 宽度的自适应，在页面加载时，调用 JqGrid 的初始化方法，将页面中 id 为 jqGrid 的 DOM 渲染为分页表格，并向后端发送请求，之后按照后端返回的 json 数据填充表格以及表格下方的分页按钮，可以参考第 15 个实验课程中 jqgrid 分页功能整合进行知识的理解，之后可以重启项目验证一下分类信息分页功能是否正常。

# 按钮事件及 Modal 框实现

添加和修改两个按钮分别绑定了触发事件，我们需要在 category.js 文件中新增 `categoryAdd()` 方法和 `categoryEdit()` 方法，两个方法中的实现为打开信息编辑框，下面我们来实现信息编辑框和两个触发事件，代码如下：(**注：完整代码位于 resources/templates/admin/category.html**)

```
        <div class="content">
            <!-- 模态框（Modal） -->
            <div class="modal fade" id="categoryModal" tabindex="-1" role="dialog" aria-labelledby="categoryModalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h6 class="modal-title" id="categoryModalLabel">Modal</h6>
                        </div>
                        <div class="modal-body">
                            <form id="categoryForm" onsubmit="return false;">
                                <div class="form-group">
                                    <div class="alert alert-danger" id="edit-error-msg" style="display: none;">
                                        错误信息展示栏。
                                    </div>
                                </div>
                                <input type="hidden" class="form-control" id="categoryId" name="categoryId">
                                <div class="form-group">
                                    <label for="categoryName" class="control-label">分类名称:</label>
                                    <input type="text" class="form-control" id="categoryName" name="categoryName"
                                           placeholder="请输入分类名称" required="true">
                                </div>
                                <div class="form-group">
                                    <label for="categoryIcon" class="control-label">分类图标:</label>
                                    <input type="hidden" class="form-control" id="categoryIcon" name="categoryIcon">
                                    <div class="col-sm-4">
                                        <img id="categoryIconImg" src="/admin/dist/img/img-upload.png"
                                             style="height: 64px;width: 64px;">
                                        <button class="btn btn-secondary" style="margin-top: 5px;margin-bottom: 5px;"
                                                id="categoryIconButton"><i
                                                class="fa fa-random"></i>&nbsp;图标切换
                                        </button>
                                    </div>
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
```

`categoryAdd()` 方法和 `categoryEdit()` 方法实现如下：(**注：完整代码位于 resources/static/admin/dist/js/category.js**)

```
function categoryAdd() {
    reset();
    $('.modal-title').html('分类添加');
    $('#categoryModal').modal('show');
}


function categoryEdit() {
    reset();
    var id = getSelectedRow();
    if (id == null) {
        return;
    }
    $('.modal-title').html('分类编辑');
    $('#categoryModal').modal('show');
    //请求数据
    $.get("/admin/categories/info/" + id, function (r) {
        if (r.resultCode == 200 && r.data != null) {
            //填充数据至modal
            $("#categoryIconImg").attr("src", r.data.categoryIcon);
            $("#categoryIconImg").attr("style", "width:64px ;height: 64px;display:block;");
            $("#categoryIcon").val(r.data.categoryIcon);
            $("#categoryName").val(r.data.categoryName);
        }
    });
    $("#categoryId").val(id);
}
```

添加方法仅仅是将 Modal 框显示，修改功能则多了一个步骤，需要将选择的记录回显到编辑框中以供修改，因此需要请求 categories/info/{id} 详情接口获取被修改的分类数据信息。

Modal 框实际效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378815845/wm)

在项目中内置了 20 个分类图标，图标在 resources/static/admin/dist/img/category 目录下，点击上图中的图标切换可以随机获取到一个图标，填写分类名称并选择合适的图标保存即可。

# 添加功能和编辑功能

在信息录入完成后可以点击信息编辑框下方的**确认**按钮，此时会进行数据的交互，js 实现代码如下：(**注：完整代码位于 resources/static/admin/dist/js/category.js**)

```
//绑定modal上的保存按钮
$('#saveButton').click(function () {
    var categoryName = $("#categoryName").val();
    if (!validCN_ENString2_18(categoryName)) {
        $('#edit-error-msg').css("display", "block");
        $('#edit-error-msg').html("请输入符合规范的分类名称！");
    } else {
        var params = $("#categoryForm").serialize();
        var url = '/admin/categories/save';
        var id = getSelectedRowWithoutAlert();
        if (id != null) {
            url = '/admin/categories/update';
        }
        $.ajax({
            type: 'POST',//方法类型
            url: url,
            data: params,
            success: function (result) {
                if (result.resultCode == 200) {
                    $('#categoryModal').modal('hide');
                    swal("保存成功", {
                        icon: "success"
                    });
                    reload();
                }
                else {
                    $('#categoryModal').modal('hide');
                    swal(result.message, {
                        icon: "error"
                    });
                }
            },
            error: function () {
                swal("操作失败", {
                    icon: "error"
                });
            }
        });
    }
});
```

由于传参和后续处理逻辑类似，为了避免太多重复代码因此将两个方法写在一起了，通过 id 是否大于 0 来确定是修改操作还是添加操作，方法步骤如下：

1. 前端对用户输入的数据进行简单的正则验证
2. 封装数据
3. 向对应的后端接口发送 Ajax 请求
4. 请求成功后提醒用户请求成功并隐藏当前的信息编辑框，同时刷新列表数据
5. 请求失败则提醒对应的错误信息

# 删除功能

删除按钮的点击触发事件为 `deleteCagegory()`，在 category.js 文件中新增如下代码：(**注：完整代码位于 resources/static/admin/dist/js/category.js**)

```
function deleteCagegory() {
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
        if(flag) {
            $.ajax({
                type: "POST",
                url: "/admin/categories/delete",
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
    });
}
```

获取用户在 jqgrid 表格中选择的需要删除的所有记录的 id，之后将参数封装并向后端发送 Ajax 请求，请求地址为 categories/delete，删除功能已经开发完成，同学们可以结合源码以及实际的功能进行学习和理解，接下来我们来进行功能测试。

# 实验楼 web ide 中操作 Spring Boot 项目

我们提供的整个项目的完整代码，请大家下载并参照源码对比学习了解各个功能模块的代码内容。

# 启动 MySQL 并新增 tb_blog_category 表

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

因为实验楼线上实验环境中 MySQL 数据库默认并没有设置密码，因此以上命令即可完成登陆，最后在命令行中执行前文给出的建表语句 SQL 即可，整个过程如下，再执行完新增表的 SQL 后，我们再去查看一下数据库中的表，可以发现 tb_blog_category 表已经在 my_blog_db 数据库中了。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378837598/wm)

# 启动项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到已解压的 My-Blog 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 mvn spring-boot:run ，之后就可以等待项目启动。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378847979/wm)

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果，之后会在浏览器中弹出 `https://********.simplelab.cn` 访问页面：`https://********.simplelab.cn/admin/login` 并登陆至后台管理首页，之后点击分类管理就可以对相关功能进行测试了，演示过程如下。

- 添加功能：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378862121/wm)

- 修改功能：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378873632/wm)

- 删除功能：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378884743/wm)

同学们可以按照文中的思路和过程自行测试，本次实验完成！