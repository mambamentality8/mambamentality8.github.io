# 自定义条件查询

### 1.需求分析

在页面输入查询条件，查询符合条件的页面信息。 
查询条件如下：
站点Id：精确匹配
模板Id：精确匹配
页面别名：模糊匹配

### 2.服务端

#### 1.Dao

使用 CmsPageRepository中的findAll(Example<S> var1, Pageable var2)方法实现，无需定义。

下边测试ﬁndAll方法实现自定义条件查询：

```
	@Test
    public void testFindAllByExample() {
        //分页参数
        int page = 0;//从0开始
        int size = 10;
        Pageable pageable = PageRequest.of(page, size);

        //条件值对象
        CmsPage cmsPage = new CmsPage();

        //要查询5a751fab6abb5044e0d19ea1站点的页面
      /* cmsPage.setSiteId("5a751fab6abb5044e0d19ea1");
        cmsPage.setTemplateId("5a962b52b00ffc514038faf7");*/

        cmsPage.setPageAliase("轮播");
        //条件匹配器
        //采用链式调用能避免我们出错
        ExampleMatcher exampleMatcher = ExampleMatcher.matching().
                //页面名称模糊查询，需要自定义字符串的匹配器实现模糊查询
                withMatcher("pageAliase", ExampleMatcher.GenericPropertyMatchers.contains());


        //定义Example
        Example<CmsPage> example = Example.of(cmsPage, exampleMatcher);
        Page<CmsPage> all = cmsPageRepository.findAll(example, pageable);
        List<CmsPage> content = all.getContent();
        System.out.println(content);
    }
```

#### 2.Service

在PageService的ﬁndlist方法中增加自定义条件查询代码

```
	@Autowired
    CmsPageRepository cmsPageRepository;


    /**
     * 页面查询方法
     *
     * @param page             页码，从1开始记数
     * @param size             每页记录数
     * @param queryPageRequest 查询条件
     * @return
     */
    public QueryResponseResult findList(int page, int size, QueryPageRequest queryPageRequest) {
        //===================条件查询====================
        if(queryPageRequest == null){
            queryPageRequest = new QueryPageRequest();
        }
        //自定义条件查询
        //定义条件匹配器
        ExampleMatcher exampleMatcher = ExampleMatcher.matching()
                .withMatcher("pageAliase", ExampleMatcher.GenericPropertyMatchers.contains());
        //条件值对象
        CmsPage cmsPage = new CmsPage();
        //设置条件值（站点id）
        if(StringUtils.isNotEmpty(queryPageRequest.getSiteId())){
            cmsPage.setSiteId(queryPageRequest.getSiteId());
        }
        //设置模板id作为查询条件
        if(StringUtils.isNotEmpty(queryPageRequest.getTemplateId())){
            cmsPage.setTemplateId(queryPageRequest.getTemplateId());
        }
        //设置页面别名作为查询条件
        if(StringUtils.isNotEmpty(queryPageRequest.getPageAliase())){
            cmsPage.setPageAliase(queryPageRequest.getPageAliase());
        }
        //定义条件对象Example
        Example<CmsPage> example = Example.of(cmsPage,exampleMatcher);

        //===================分页功能====================
        if (page <= 0) {
            page = 1;
        }
        page = page - 1;
        if (size <= 0) {
            size = 10;
        }
        Pageable pageable = PageRequest.of(page, size);
        //实现自定义条件查询并且分页查询
        Page<CmsPage> all = cmsPageRepository.findAll(example,pageable);
        QueryResult queryResult = new QueryResult();
        //数据列表
        queryResult.setList(all.getContent());
        //数据总记录数
        queryResult.setTotal(all.getTotalElements());
        QueryResponseResult queryResponseResult = new QueryResponseResult(CommonCode.SUCCESS, queryResult);
        return queryResponseResult;
    }
```

#### 3.Controller

```
@RestController
@RequestMapping("/cms/page")
public class CmsPageController implements CmsPageControllerApi {
    @Autowired
    PageService pageService;

    @Override
    @GetMapping("/list/{page}/{size}")
    public QueryResponseResult findList(@PathVariable("page") int page, @PathVariable("size")int size, QueryPageRequest queryPageRequest) {

        /*//暂时采用测试数据，测试接口是否可以正常运行
        QueryResult queryResult = new QueryResult();
        queryResult.setTotal(2);
        //静态数据列表
        List list = new ArrayList();
        CmsPage cmsPage = new CmsPage();
        cmsPage.setPageName("测试页面");
        list.add(cmsPage);
        queryResult.setList(list);
        QueryResponseResult queryResponseResult = new QueryResponseResult(CommonCode.SUCCESS,queryResult);
        return queryResponseResult;*/

        return pageService.findList(page,size,queryPageRequest);
    }
}
```

####  4.测试

使用SwaggerUI

```
http://localhost:31001/swagger-ui.html#!
```

![1569483758133](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1569483758133.png)

### 3.前端

####  1.页面

##### 1.添加下拉框

```
<!--查询表单-->
    <el-form :model="params">
      <el-select v-model="params.siteId" placeholder="请选择站点">
        <el-option
          v-for="item in siteList"
          :key="item.siteId"
          :label="item.siteName"
          :value="item.siteId">
        </el-option>
      </el-select>
      页面别名：<el-input v-model="params.pageAliase"  style="width: 100px"></el-input>
      <el-button type="primary" size="small" @click="query">查询</el-button>
      <router-link :to="{path:'/cms/page/add',query:{
        page:this.params.page,
        siteId:this.params.siteId
      }}">
        <el-button  type="primary" size="small">新增页面</el-button>
      </router-link>
    </el-form>
```

##### 2.添加数据模型对象

```
data() {
      return {
        siteList: [],//站点列表
        list: [],
        //数据总条数
        total: 0,
        params: {
          siteId: '',
          pageAliase: '',
          //当前页
          page: 1,
          //每页显示条数
          size: 10
        }
      }
    },
```

##### 3.在钩子方法中 构建siteList站点列表

```
mounted() {
      //默认查询页面
      this.query()

      this.siteList = [
        {
          siteId: '5a751fab6abb5044e0d19ea1',
          siteName: '门户主站'
        },
        {
          siteId: '102',
          siteName: '测试站'
        }
      ]
    }
```

#### 2.Api调用

##### 1.扩充查询条件params

```
methods: {
      query: function () {
        // alert('查询')
        //调用服务端的接口
        cmsApi.page_list(this.params.page, this.params.size,this.params).then((res) => {
          //将res结果数据赋值给数据模型对象
          this.list = res.queryResult.list;
          this.total = res.queryResult.total;
        })
      },
```

##### 2.导入类库将json对象转换成k,v对

```
//public是对axios的工具类封装，定义了http请求方法
import http from './../../../base/api/public'
//导入解析json对象工具类
import querystring from 'querystring'
//@相当于src目录
let sysConfig = require('@/../config/sysConfig')

let apiUrl = sysConfig.xcApiUrlPre;
//页面查询
export const page_list = (page, size, params) => {
  //将json对象转成key/value对
  let queryString = querystring.stringify(params)
  //请求服务端的页面查询接口
  return http.requestQuickGet(apiUrl + '/cms/page/list/' + page + '/' + size+"?"+queryString);
}
```

# 新增页面

### 1.新增页面接口定义

在api工程中添加接口

```
	@ApiOperation("添加页面")
    public CmsPageResult add(CmsPage cmsPage);
```

### 2.新增页面服务端开发

#### 1.创建页面唯一索引(防止添加页面时页面重复)

在cms_page上创建页面名称、站点Id、页面webpath为唯一索引

![1569491014620](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1569491014620.png)

![1569491099565](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1569491099565.png)

![1569491140012](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1569491140012.png)

####  2.Service

```
	//新增页面
    public CmsPageResult add(CmsPage cmsPage) {
       //校验页面名称、站点Id、页面webpath的唯一性
        //根据页面名称、站点Id、页面webpath去cms_page集合，如果查到说明此页面已经存在，如果查询不到再继续添加
        CmsPage cmsPage1 = cmsPageRepository.findByPageNameAndSiteIdAndPageWebPath(cmsPage.getPageName(), cmsPage.getSiteId(), cmsPage.getPageWebPath());
        if(cmsPage1==null){
            //调用dao新增页面
            cmsPage.setPageId(null);
            cmsPageRepository.save(cmsPage);
            return new CmsPageResult(CommonCode.SUCCESS,cmsPage);
        }
        //添加失败
        return new CmsPageResult(CommonCode.FAIL,null);
    }
```

#### 3.controller

```
    @PostMapping("/add")
    public CmsPageResult add(@RequestBody  CmsPage cmsPage) {
        return pageService.add(cmsPage);
    }
```

#### 4.接口测试 

使用SwaggerUI

```
http://localhost:31001/swagger-ui.html#!
```

### 3.新增页面前端开发

#### 1.编写page_add.vue页面

使用Element-UI的form组件编写在src/module/cms/page下添加表单内容，页面效果如下：

![1569495200519](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1569495200519.png)

导入模板

```
<template>
  <div>
    新增页面...
  </div>
</template>
<script>
  import * as cmsApi from '../api/cms'

  export default {
    data() {
      return {

      }
    },
    methods: {

    },
    mounted() {

    }
  }
</script>
<style>
  /*编写页面样式，不是必须*/
</style>
```

#### 2.配置路由

在cms模块的router文件中配置“添加页面”的路由：

```
{path:'/cms/page/add',name:'新增页面',component: page_add,hidden:true}
```

不需要新增页面在左侧栏显示所以hidden:true

测试，在浏览器地址栏输入http://localhost:11000/cms/page/list#/cms/page/add

#### 3.在页面列表添加“添加页面”的按钮

实际情况是用户进入页面查询列表，点击“新增页面”按钮进入新增页面窗口。 在查询按钮的旁边添加：

```
      <router-link :to="{path:'/cms/page/add'}">
        <el-button type="primary" size="small">新增页面</el-button>
      </router-link>
```

router-link是vue提供的路由功能，用于在页面生成路由链接，最终在html渲染后就是<a标签。 
 to：目标路由地址

#### 4.完善页面内容

```
<template>
<div>
  <el-form   :model="pageForm" label-width="80px" :rules="pageFormRules" ref="pageForm">
    <el-form-item label="所属站点" prop="siteId">
      <el-select v-model="pageForm.siteId" placeholder="请选择站点">
        <el-option
          v-for="item in siteList"
          :key="item.siteId"
          :label="item.siteName"
          :value="item.siteId">
        </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="选择模版" prop="templateId">
      <el-select v-model="pageForm.templateId" placeholder="请选择">
        <el-option
          v-for="item in templateList"
          :key="item.templateId"
          :label="item.templateName"
          :value="item.templateId">
        </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="页面名称" prop="pageName">
      <el-input v-model="pageForm.pageName" auto-complete="off" ></el-input>
    </el-form-item>

    <el-form-item label="别名" prop="pageAliase">
      <el-input v-model="pageForm.pageAliase" auto-complete="off" ></el-input>
    </el-form-item>
    <el-form-item label="访问路径" prop="pageWebPath">
      <el-input v-model="pageForm.pageWebPath" auto-complete="off" ></el-input>
    </el-form-item>

    <el-form-item label="物理路径" prop="pagePhysicalPath">
      <el-input v-model="pageForm.pagePhysicalPath" auto-complete="off" ></el-input>
    </el-form-item>

    <el-form-item label="类型">
      <el-radio-group v-model="pageForm.pageType">
        <el-radio class="radio" label="0">静态</el-radio>
        <el-radio class="radio" label="1">动态</el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item label="创建时间">
      <el-date-picker type="datetime" placeholder="创建时间" v-model="pageForm.pageCreateTime"></el-date-picker>
    </el-form-item>

  </el-form>
  <div slot="footer" class="dialog-footer">
    <el-button type="primary" @click="addSubmit" >提交</el-button>
    <el-button type="primary" @click="go_back" >返回</el-button>
  </div>
</div>
</template>
<script>
  /*编写页面静态部分，即model及vm部分。*/
  import * as cmsApi from '../api/cms'
  export default {
    data() {
      return {
        siteList:[],
        templateList:[],
        pageForm:{
          siteId:'',
          templateId:'',
          pageName: '',
          pageAliase: '',
          pageWebPath: '',
          pageParameter:'',
          pagePhysicalPath:'',
          pageType:'',
          pageCreateTime: new Date()
        },
        pageFormRules: {
          siteId:[
            {required: true, message: '请选择站点', trigger: 'blur'}
          ],
          templateId:[
            {required: true, message: '请选择模版', trigger: 'blur'}
          ],
          pageName: [
            {required: true, message: '请输入页面名称', trigger: 'blur'}
          ],
          pageWebPath: [
            {required: true, message: '请输入访问路径', trigger: 'blur'}
          ],
          pagePhysicalPath: [
            {required: true, message: '请输入物理路径', trigger: 'blur'}
          ]
        }
      }
    },
    methods:{
      addSubmit:function(){
        this.$refs['pageForm'].validate((valid) => {
          if (valid) {//表单校验成功
            //确认提示
            this.$confirm('您确认提交吗?', '提示', { }).then(() => {
              //调用page_add方法请求服务端的新增页面接口
              cmsApi.page_add(this.pageForm).then(res=>{
                //解析服务端响应内容
                if(res.success){
                  /*this.$message({
                    message: '提交成功',
                    type: 'success'
                  })*/
                  this.$message.success("提交成功")
                  //将表单清空
                  this.$refs['pageForm'].resetFields();
                }else if(res.message){
                  this.$message.error(res.message)
                }else{
                  this.$message.error("提交失败")
                }
              });
            })

          }
        });
      },
      //返回
      go_back:function () {
        this.$router.push({
          path:'/cms/page/list',
          query:{
            page:this.$route.query.page,//取出路由中的参数
            siteId:this.$route.query.siteId
          }
        })
      }
    },
    mounted(){
      //初始化站点列表
      this.siteList = [
        {
          siteId:'5a751fab6abb5044e0d19ea1',
          siteName:'门户主站'
        },
        {
          siteId:'102',
          siteName:'测试站'
        }
      ]
      //模板列表
      this.templateList = [
        {
          templateId:'5a962b52b00ffc514038faf7',
          templateName:'首页'
        },
        {
          templateId:'5a962bf8b00ffc514038fafa',
          templateName:'轮播图'
        }
      ]
    }
  }
</script>
<style>
  /*编写页面样式，不是必须*/
</style>
```

#### 5.添加返回

进入新增页面后只能通过菜单再次进入页面列表，可以在新增页面添加“返回”按钮，点击返回按钮返回到页面列 表。

#####  1.在新增页面上添加返回按钮

```
<el-button type="primary" @click="go_back" >返回</el-button>
```

##### 2.在点击新增页面的时候将参数带过去

```
<router-link :to="{path:'/cms/page/add',query:{
        page:this.params.page,
        siteId:this.params.siteId
      }}">
```

##### 3.点击返回的时候取出地址栏的参数并回传给列表页面

```
go_back:function () {
        this.$router.push({
          path:'/cms/page/list',
          query:{
            page:this.$route.query.page,//取出路由中的参数
            siteId:this.$route.query.siteId
          }
        })
      }
```

##### 4.利用钩子函数取出地址栏的参数,赋值给数据对象

```
created(){
      this.params.page = Number.parseInt(this.$route.query.page || 1)
      this.params.siteId = this.$route.query.siteId || ''
    },
```

为什么不用mounted而使用created?

created:在模板渲染成html前调用，即通常初始化某些属性值，然后再渲染成视图。(渲染未完成)

mounted:在模板渲染成html后调用，通常是初始化页面完成后，再对html的dom节点进行一些需要的操作。(渲染完成)

#### 6.表单校验

##### 1.在表单标签上添加:rules标记

```
<el‐form   :model="pageForm" :rules="pageFormRules" label‐width="80px" >
```

##### 2.在数据模型中配置校验规则pageFormRules：

```
 data() {
      return {
        siteList:[],
        templateList:[],
        pageForm:{
          siteId:'',
          templateId:'',
          pageName: '',
          pageAliase: '',
          pageWebPath: '',
          pageParameter:'',
          pagePhysicalPath:'',
          pageType:'',
          pageCreateTime: new Date()
        },
        pageFormRules: {
          siteId:[
            {required: true, message: '请选择站点', trigger: 'blur'}
          ],
          templateId:[
            {required: true, message: '请选择模版', trigger: 'blur'}
          ],
          pageName: [
            {required: true, message: '请输入页面名称', trigger: 'blur'}
          ],
          pageWebPath: [
            {required: true, message: '请输入访问路径', trigger: 'blur'}
          ],
          pagePhysicalPath: [
            {required: true, message: '请输入物理路径', trigger: 'blur'}
          ]
        }
      }
    },
```

##### 3.点击提交按钮触发校验

###### 1.在form表单上添加 ref属性（ref="pageForm"）在校验时引用此表单对象

```
<el-form   :model="pageForm" label-width="80px" :rules="pageFormRules" ref="pageForm">
```

###### 2.执行校验

```
methods:{
      addSubmit:function(){
        this.$refs['pageForm'].validate((valid) => {
          if (valid) {//表单校验成功
            alert('提交')
          }else {
            alert('提交失败')
            return false;
          }
        });
      },
      //返回
      go_back:function () {
        this.$router.push({
          path:'/cms/page/list',
          query:{
            page:this.$route.query.page,//取出路由中的参数
            siteId:this.$route.query.siteId
          }
        })
      }
    },
```

#### 7.Api调用

##### 1.在cms.js中定义page_add方法.

```
//页面添加
export const page_add = params => {
  //请求服务端的页面添加接口
  return http.requestPost(apiUrl+'/cms/page/add',params)
}
```

##### 2.page_add页面定义一个请求

```
addSubmit:function(){
        this.$refs['pageForm'].validate((valid) => {
          if (valid) {//表单校验成功
            //确认提示
            this.$confirm('您确认提交吗?', '提示', { }).then(() => {
              //调用page_add方法请求服务端的新增页面接口
              cmsApi.page_add(this.pageForm).then(res=>{
                //解析服务端响应内容
                if(res.success){
                  /*this.$message({
                    message: '提交成功',
                    type: 'success'
                  })*/
                  this.$message.success("提交成功")
                  //将表单清空
                  this.$refs['pageForm'].resetFields();
                }else if(res.message){
                  this.$message.error(res.message)
                }else{
                  this.$message.error("提交失败")
                }
              });
            })
          }
        });
      },
```

##### 3.测试

观察CmsPageController

# 修改页面

### 1.修改页面接口定义

在api工程中添加修改接口

```
    @ApiOperation("通过ID查询页面")
    public CmsPage findById(String id);

    @ApiOperation("修改页面")
    public CmsPageResult edit(String id, CmsPage cmsPage);
```

### 2.修改页面服务端开发

#### 1.Dao

使用 Spring Data Mongo提供的ﬁndById方法完成根据主键查询 。

使用 Spring Data Mongo提供的save方法完成数据保存 。

#### 2.Service

##### 1.根据id查询页面

```
    //根据页面id查询页面
    public CmsPage getById(String id){
        Optional<CmsPage> optional = cmsPageRepository.findById(id);
        if(optional.isPresent()){
            CmsPage cmsPage = optional.get();
            return cmsPage;
        }
        return null;
    }
```

##### 2.根据id修改页面

```
    //根据页面id查询页面
    public CmsPage getById(String id){
        Optional<CmsPage> optional = cmsPageRepository.findById(id);
        if(optional.isPresent()){
            CmsPage cmsPage = optional.get();
            return cmsPage;
        }
        return null;
    }
```

#### 3.Controller

##### 1.根据id查询页面

```
    @Override
    @GetMapping("/get/{id}")
    public CmsPage findById(@PathVariable("id") String id) {
        CmsPage byId = pageService.getById(id);
        return byId;
    }
```

##### 2.保存页面信息

```
    @PutMapping("/edit/{id}")//这里使用put方法，http 方法中put表示更新
    public CmsPageResult edit(@PathVariable("id")String id, @RequestBody CmsPage cmsPage) {
        return pageService.update(id,cmsPage);
    }
```

### 3.修改页面前端开发

#### 1.在页面列表添加“编辑”链接

```
<el-table-column label="操作" width="80">
        <template slot-scope="page">
          <el-button
            size="small"type="text"
            @click="edit(page.row.pageId)">编辑
          </el-button>
        </template>
      </el-table-column>
```

slot-scope插槽page就相当于整个列表的数据

#### 2.编写edit方法

```
      edit:function(pageId){
        //打开修改页面
        this.$router.push({
          path:'/cms/page/edit/'+pageId
        })
      },
```

#### 3.配置路由

进入修改页面传入pageId

```
import page_edit from '@/module/cms/page/page_edit.vue';
{path: '/cms/page/edit/:pageId', name: '修改页面', component: page_edit, hidden: true},
```

#### 4.编写page_edit页面

```
<template>
  <div>
    <el-form   :model="pageForm" label-width="80px" :rules="pageFormRules" ref="pageForm" >
      <el-form-item label="所属站点" prop="siteId">
        <el-select v-model="pageForm.siteId" placeholder="请选择站点">
          <el-option
            v-for="item in siteList"
            :key="item.siteId"
            :label="item.siteName"
            :value="item.siteId">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="选择模版" prop="templateId">
        <el-select v-model="pageForm.templateId" placeholder="请选择">
          <el-option
            v-for="item in templateList"
            :key="item.templateId"
            :label="item.templateName"
            :value="item.templateId">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="页面名称" prop="pageName">
        <el-input v-model="pageForm.pageName" auto-complete="off" ></el-input>
      </el-form-item>

      <el-form-item label="别名" prop="pageAliase">
        <el-input v-model="pageForm.pageAliase" auto-complete="off" ></el-input>
      </el-form-item>
      <el-form-item label="访问路径" prop="pageWebPath">
        <el-input v-model="pageForm.pageWebPath" auto-complete="off" ></el-input>
      </el-form-item>

      <el-form-item label="物理路径" prop="pagePhysicalPath">
        <el-input v-model="pageForm.pagePhysicalPath" auto-complete="off" ></el-input>
      </el-form-item>
      <el-form-item label="数据Url" prop="dataUrl">
        <el-input v-model="pageForm.dataUrl" auto-complete="off" ></el-input>
      </el-form-item>
      <el-form-item label="类型">
        <el-radio-group v-model="pageForm.pageType">
          <el-radio class="radio" label="0">静态</el-radio>
          <el-radio class="radio" label="1">动态</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker type="datetime" placeholder="创建时间" v-model="pageForm.pageCreateTime"></el-date-picker>
      </el-form-item>

    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="go_back">返回</el-button>
      <el-button type="primary" @click.native="editSubmit" :loading="addLoading">提交</el-button>
    </div>
  </div>
</template>
<script>
  import * as cmsApi from '../api/cms'
  export default{
    data(){
      return {
        //页面id
        pageId:'',
        //模版列表
        templateList:[],
        addLoading: false,//加载效果标记
        //新增界面数据
        pageForm: {
          siteId:'',
          templateId:'',
          pageName: '',
          pageAliase: '',
          pageWebPath: '',
          dataUrl:'',
          pageParameter:'',
          pagePhysicalPath:'',
          pageType:'',
          pageCreateTime: new Date()
        },
        pageFormRules: {
          siteId:[
            {required: true, message: '请选择站点', trigger: 'blur'}
          ],
          templateId:[
            {required: true, message: '请选择模版', trigger: 'blur'}
          ],
          pageName: [
            {required: true, message: '请输入页面名称', trigger: 'blur'}
          ],
          pageWebPath: [
            {required: true, message: '请输入访问路径', trigger: 'blur'}
          ],
          pagePhysicalPath: [
            {required: true, message: '请输入物理路径', trigger: 'blur'}
          ]
        },
        siteList:[]
      }
    },
    methods:{
      go_back(){
        this.$router.push({
          path: '/cms/page/list', query: {
            page: this.$route.query.page,
            siteId:this.$route.query.siteId
          }
        })
      },
      editSubmit(){
        this.$refs.pageForm.validate((valid) => {//表单校验
          if (valid) {//表单校验通过
            this.$confirm('确认提交吗？', '提示', {}).then(() => {
              this.addLoading = true;
              //修改提交请求服务端的接口
              cmsApi.page_edit(this.pageId,this.pageForm).then((res) => {
                  console.log(res);
                if(res.success){
                  this.addLoading = false;
                  this.$message({
                    message: '提交成功',
                    type: 'success'
                  });
                  //返回
                  this.go_back();

                }else{
                  this.addLoading = false;
                  this.$message.error('提交失败');
                }
              });
            });
          }
        });
      }

    },
    created: function () {
      this.pageId=this.$route.params.pageId;
      //根据主键查询页面信息
      cmsApi.page_get(this.pageId).then((res) => {
        console.log(res);
        if(res){
          this.pageForm = res;
        }
      });
    },
    mounted:function(){

      //初始化站点列表
      this.siteList = [
        {
          siteId:'5a751fab6abb5044e0d19ea1',
          siteName:'门户主站'
        },
        {
          siteId:'102',
          siteName:'测试站'
        }
      ]
      //模板列表
      this.templateList = [
        {
          templateId:'5a962b52b00ffc514038faf7',
          templateName:'首页'
        },
        {
          templateId:'5a962bf8b00ffc514038fafa',
          templateName:'轮播图'
        }
      ]
    }
  }
</script>
<style>

</style>
```

#### 5.page_edit页面请求服务端的接口

```
      editSubmit(){
        this.$refs.pageForm.validate((valid) => {//表单校验
          if (valid) {//表单校验通过
            this.$confirm('确认提交吗？', '提示', {}).then(() => {
              this.addLoading = true;
              //修改提交请求服务端的接口
              cmsApi.page_edit(this.pageId,this.pageForm).then((res) => {
                  console.log(res);
                if(res.success){
                  this.addLoading = false;
                  this.$message({
                    message: '提交成功',
                    type: 'success'
                  });
                  //返回
                  this.go_back();

                }else{
                  this.addLoading = false;
                  this.$message.error('提交失败');
                }
              });
            });
          }
        });
      }
```

#### 6.在cms.js文件中定义根据id查询页面

```
//根据id查询页面
export const page_get = id =>{
  return http.requestQuickGet(apiUrl+'/cms/page/get/'+id)
}
```

#### 7.进入修改页面应该默认去查询页面信息

```
created: function () {
      this.pageId=this.$route.params.pageId;
      //根据主键查询页面信息
      cmsApi.page_get(this.pageId).then((res) => {
        console.log(res);
        if(res){
          this.pageForm = res;
        }
      });
    },
```

$route.params.pageId : 当URL是以/a/b/c的方式传参的时候采用此api

$route.query.pageId : 当URL是以?k=v的方式传参的时候采用此api

#### 8.在cms.js文件中添加定义修改页面提交

```
//修改页面提交
export const page_edit = (id,params) =>{
 return http.requestPut(apiUrl+'/cms/page/edit/'+id,params)
}
```

# 删除页面

### 1.删除页面接口定义

```
    //删除页面
    @ApiOperation("删除页面")
    public ResponseResult delete(String id);
```

### 2.删除页面服务端开发

#### 1.Dao

使用 Spring Data提供的deleteById方法完成删除操作 。

#### 2.Service

```
    //根据id删除页面
    public ResponseResult delete(String id){
        //先查询一下
        Optional<CmsPage> optional = cmsPageRepository.findById(id);
        if(optional.isPresent()){
            cmsPageRepository.deleteById(id);
            return new ResponseResult(CommonCode.SUCCESS);
        }
        return new ResponseResult(CommonCode.FAIL);
    }
```

#### 3.controller

```
    @DeleteMapping("/del/{id}")
    public ResponseResult delete(@PathVariable("id") String id) {
        return pageService.delete(id);
    }
```

#### 4.接口测试 

使用SwaggerUI

```
http://localhost:31001/swagger-ui.html#!
```

### 3.删除页面前端开发

#### 1.页面添加删除按钮

```
<el-table-column label="操作" width="80">
        <template slot-scope="page">
          <el-button
            size="small"type="text"
            @click="edit(page.row.pageId)">编辑
          </el-button>
          <el-button
            size="small"type="text"
            @click="del(page.row.pageId)">删除
          </el-button>
        </template>
      </el-table-column>
```

#### 2.编写del方法

```
      del:function (pageId) {
        this.$confirm('您确认删除吗?', '提示', { }).then(() => {

          //调用服务端接口
          cmsApi.page_del(pageId).then(res=>{

            if(res.success){
              this.$message.success("删除成功")
              //刷新页面
              this.query()
            }else{
              this.$message.error("删除失败")
            }
          })
        })
      },
```

#### 3.在cms.js文件中添加定义删除页面

```
//删除页面
export const page_del= (id) =>{
  return http.requestDelete(apiUrl+'/cms/page/del/'+id)
}
```

# 异常处理

问题:

1、上边的代码只要操作不成功仅向用户返回“错误代码：11111，失败信息：操作失败”，无法区别具体的错误信 息。 
2、service方法在执行过程出现异常在哪捕获？在service中需要都加try/catch，如果在controller也需要添加 
try/catch，代码冗余严重且不易维护。

解决方案： 
1、在Service方法中的编码顺序是先校验判断，有问题则抛出具体的异常信息，最后执行具体的业务操作，返回成功信息。
2、在统一异常处理类中去捕获异常，无需controller捕获异常，向用户返回统一规范的响应信息。 

### 修改PageService类的添加页面方法

```
	//新增页面
    public CmsPageResult add(CmsPage cmsPage) {
        if(cmsPage == null){
            //抛出空指针异常，非法参数异常..指定异常信息的内容

        }
        //校验页面名称、站点Id、页面webpath的唯一性
        //根据页面名称、站点Id、页面webpath去cms_page集合，如果查到说明此页面已经存在，如果查询不到再继续添加
        CmsPage cmsPage1 = cmsPageRepository.findByPageNameAndSiteIdAndPageWebPath(cmsPage.getPageName(), cmsPage.getSiteId(), cmsPage.getPageWebPath());
        if(cmsPage1!=null){
            //页面已经存在
            //抛出异常，异常内容就是页面已经存在
            /*  ExceptionCast.cast(CmsCode.CMS_ADDPAGE_EXISTSNAME);*/
        }
		
        //页面不存在,调用dao新增页面
        cmsPage.setPageId(null);
        cmsPageRepository.save(cmsPage);
        return new CmsPageResult(CommonCode.SUCCESS,cmsPage);

    }
```

### 异常处理流程

#### 可预知的异常:

```
1、自定义异常类型。
2、自定义错误代码及错误信息。
3、对于可预知的异常由程序员在代码中主动抛出，由SpringMVC统一捕获。 
 可预知异常是程序员在代码中手动抛出本系统定义的特定异常类型，由于是程序员抛出的异常，通常异常信息比较 齐全，程序员在抛出时会指定错误代码及错误信息，获取异常信息也比较方便。
```

#### 不可预知的异常:

```
1、对于不可预知的异常（运行时异常）由SpringMVC统一捕获Exception类型的异常。 
 不可预知异常通常是由于系统出现bug、或一些不要抗拒的错误（比如网络中断、服务器宕机等），异常类型为 RuntimeException类型（运行时异常）,然后跳到系统异常请联系管理员。
2、对于这些不可预知的异常,有一些我们可以通过经验知道他的error_code和error_info,然后跳入我们提前设计好的一个Map。
```



系统对异常的处理使用统一的异常处理流程：

4、
5、可预知的异常及不可预知的运行时异常最终会采用统一的信息格式（错误代码+错误信息）来表示，最终也会随 请求响应给客户端。

![1569642210654](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1569642210654.png)

### 可预知的异常的处理:

#### 1.自定义异常类

在common工程自定义异常类型

```
public class CustomException extends RuntimeException {
    //错误代码
    ResultCode resultCode;

    public CustomException(ResultCode resultCode) {
        //异常信息为错误代码+异常信息
        super("错误代码：" + resultCode.code() + "错误信息：" + resultCode.message());
        this.resultCode = resultCode;
    }

    public ResultCode getResultCode() {
        return resultCode;
    }
}
```

throw new Exception();  对代码没有入侵

#### 2.在cms工程封装异常抛出工具类

```
public class ExceptionCast {
    public static void cast(ResultCode resultCode){
        throw new CustomException(resultCode);
    }
}
```

#### 3.定义异常捕获类

使用 @ControllerAdvice和@ExceptionHandler注解来捕获指定类型的异常

```
@ControllerAdvice//控制器增强
public class ExceptionCatch {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExceptionCatch.class);

    //捕获CustomException此类异常
    @ExceptionHandler(CustomException.class)
    public ResponseResult customException(CustomException customException) {
        //记录日志
        LOGGER.error("catch exception:{}", customException.getMessage());
        ResultCode resultCode = customException.getResultCode();
        return new ResponseResult(resultCode);
    }
}
```

#### 4.异常处理测试

##### 1.修改pageService新增页面的方法,添加抛出异常代码

```
    //新增页面
    public CmsPageResult add(CmsPage cmsPage) {
        if(cmsPage == null){
            //抛出异常，非法参数异常..指定异常信息的内容

        }
        //校验页面名称、站点Id、页面webpath的唯一性
        //根据页面名称、站点Id、页面webpath去cms_page集合，如果查到说明此页面已经存在，如果查询不到再继续添加
        CmsPage cmsPage1 = cmsPageRepository.findByPageNameAndSiteIdAndPageWebPath(cmsPage.getPageName(), cmsPage.getSiteId(), cmsPage.getPageWebPath());
        if(cmsPage1!=null){
            //页面已经存在
            //抛出异常，异常内容就是页面已经存在
            ExceptionCast.cast(CmsCode.CMS_ADDPAGE_EXISTSNAME);
        }

        //调用dao新增页面
        cmsPage.setPageId(null);
        cmsPageRepository.save(cmsPage);
        return new CmsPageResult(CommonCode.SUCCESS,cmsPage);

    }
```

##### 2.添加包扫描

```
@ComponentScan(basePackages = "com.xuecheng.framework")//扫描common工程下的类
```

##### 3.在ExceptionCatch类上添加注解

```
@ResponseBody
```

##### 4.使用SwaggerUI测试

```
http://localhost:31001/swagger-ui.html#!
```

##### 5.在page_add页面判断回调的值

```
addSubmit:function(){
        this.$refs['pageForm'].validate((valid) => {
          if (valid) {//表单校验成功
            //确认提示
            this.$confirm('您确认提交吗?', '提示', { }).then(() => {
              //调用page_add方法请求服务端的新增页面接口
              cmsApi.page_add(this.pageForm).then(res=>{
                //解析服务端响应内容
                if(res.success){
                  /*this.$message({
                    message: '提交成功',
                    type: 'success'
                  })*/
                  this.$message.success("提交成功")
                  //将表单清空
                  this.$refs['pageForm'].resetFields();
                }else if(res.message){
                  this.$message.error(res.message)
                }else{
                  this.$message.error("提交失败")
                }
              });
            })
          }
        });
      },
```

### 不可预知异常(框架抛出来的)

在ExceptionCatch中

```
    //捕获Exception此类异常
    @ExceptionHandler(Exception.class)
    public ResponseResult customException(Exception exception) {
        //记录日志
        LOGGER.error("catch exception:{}", exception.getMessage());

        return null;
    }
```

