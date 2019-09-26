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

