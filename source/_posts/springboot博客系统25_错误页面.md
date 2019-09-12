# 实验介绍

#### 实验内容

在 SSM 或者 SSH 组合框架开发 web 项目时，想要定义错误页面的话，只需要在 web.xml 配置文件中进行设置即可，但是在 Spring Boot 项目中并没有该配置文件，本实验将在 Spring Boot 项目中进行自定义错误页面的配置。

#### 实验知识点

- 自定义错误页面

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

# 自定义错误页面

在项目中为了使得用户获得更友好的交互体验，对于错误页面，我们常常会使用自定义的页面，这些页面通常会单独设计和实现，页面的视觉效果和提示信息往往会更加丰富。

在 SSM 或者 SSH 组合框架开发 web 项目时，想要自定义错误页面通常非常简单，我们通过拦截或者在 web.xml 中设置对于错误码的错误页面即可，然而到了 Spring Boot 项目开发中，已经没有了之前的 web.xml 配置文件，SpringBootServletInitializer 初始化 Servlet 代替了 web.xml，虽然 Spring Boot 也提供了错误页面，但是可能不太能够满足实际建站时的需求，这里我简单的整理了两个缺点。

首先是**页面效果较为单调**，自定义错误页面效果如下：

![img](https://doc.shiyanlou.com/document-uid18510labid10308timestamp1552987144443.png/wm)

相信大家对于我们系统中的大部分页面都有印象，虽然这个博客系统的页面效果不至于说是美轮美奂，但是视觉效果也还是比较简洁美观的，如果用户在浏览博客的时候忽然看到了上面这个页面，可能会觉得有点不自然，Spring Boot 提供的自定义错误页面太过于简单，与我们系统的页面效果对比起来显得过于单调。

第二个问题就是**容易暴露业务信息**，报错如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381286416/wm)

以上页面是一个错误码为 500 而导致的错误页面效果，下方的错误信息也直接将真实原因暴露了出来，无法连接数据库导致的该错误，当然，这只是举了其中一个例子而已，如果有其他原因导致了 500 错误，可能也会暴露出相应的业务信息，因此不太建议直接使用 Spring Boot 提供的错误页面。

基于以上两个原因，部分开发人员会想要修改这种错误页面，但是把 web.xml 重新加回到 Spring Boot 项目中，这种方案虽然可以实现，但是极不合理，也不是特别提倡这种方案，下面我们通过一个实践案例在 Spring Boot 项目中实现自定义错误页面的配置和显示。

# 实现步骤

#### ErrorController

ErrorController 是 Spring Boot 提供的一种错误页面配置方案，使用 ErrorController 这种方式是比较简单的一种方案，在 `controller.common` 包中新增 ErrorPageController.java 并实现 ErrorController 类，代码如下：

```
package com.lou.springboot.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.error.ErrorAttributes;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;
@Controller
public class ErrorPageController implements ErrorController {
    private static ErrorPageController errorPageController;
    @Autowired
    private ErrorAttributes errorAttributes;
    private final static String ERROR_PATH = "/error";
    public ErrorPageController(ErrorAttributes errorAttributes) {
        this.errorAttributes = errorAttributes;
    }
    public ErrorPageController() {
        if (errorPageController == null) {
            errorPageController = new ErrorPageController(errorAttributes);
        }
    }
    @RequestMapping(value = ERROR_PATH, produces = "text/html")
    public ModelAndView errorHtml(HttpServletRequest request) {
        HttpStatus status = getStatus(request);
        if (HttpStatus.BAD_REQUEST == status) {
            return new ModelAndView("error/error_400");
        } else if (HttpStatus.NOT_FOUND == status) {
            return new ModelAndView("error/error_404");
        } else {
            return new ModelAndView("error/error_5xx");
        }
    }
    @RequestMapping(value = ERROR_PATH)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> error(HttpServletRequest request) {
        Map<String, Object> body = getErrorAttributes(request, getTraceParameter(request));
        HttpStatus status = getStatus(request);
        return new ResponseEntity<Map<String, Object>>(body, status);
    }

    @Override
    public String getErrorPath() {
        return ERROR_PATH;
    }

    private boolean getTraceParameter(HttpServletRequest request) {
        String parameter = request.getParameter("trace");
        if (parameter == null) {
            return false;
        }
        return !"false".equals(parameter.toLowerCase());
    }

    protected Map<String, Object> getErrorAttributes(HttpServletRequest request, boolean includeStackTrace) {
        WebRequest webRequest = new ServletWebRequest(request);
        return this.errorAttributes.getErrorAttributes(webRequest, includeStackTrace);
    }

    private HttpStatus getStatus(HttpServletRequest request) {
        Integer statusCode = (Integer) request
                .getAttribute("javax.servlet.error.status_code");
        if (statusCode != null) {
            try {
                return HttpStatus.valueOf(statusCode);
            } catch (Exception ex) {
            }
        }
        return HttpStatus.INTERNAL_SERVER_ERROR;
    }
}
```

错误页面的实现逻辑主要在 `errorHtml()` 方法，在实现代码中根据当前的错误码来转发到我们配置的错误页面，在这里我们只做了 3 个错误页面，分别是 400 、404 和 5xx 的错误页面，通过判断这些错误码将页面转发到 error 目录下对应的页面中，接下来我们在项目中新增这几个页面的 html 代码。

# 错误页面

之后我们在 templates 目录下新建 error 目录，之后在该目录下新建对应的错误页面，分别是 400.html、404.html、5xx.html，页面效果如下：

- 400

  ![img](https://doc.shiyanlou.com/document-uid18510labid10308timestamp1552987162169.png/wm)

- 404

  ![img](https://doc.shiyanlou.com/document-uid18510labid10308timestamp1552987176750.png/wm)

- 5xx

  ![img](https://doc.shiyanlou.com/document-uid18510labid10308timestamp1552987188365.png/wm)

由于页面代码太多就不贴在文章中了，同学们在实验时可以直接下载本节课程的代码。

此时的目录结构如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381323526/wm)

目前我们只添加了 3 个错误页面，如果在你的项目中需要设置更多的错误页面也可以继续增加，增加后也需要对应的修改 ErrorPageController.java 类中的 `errorHtml()` 方法以使得能够转发到这些页面。

因为该博客系统是一个开源在 GitHub 上的项目，所以我又在下方添加了一个可以直接提交错误的按钮，用户点击后可以直接在 My-Blog 仓库中提 issue。

添加如下代码：

```
    <p>报告问题 <a href="https://github.com/ZHENFENG13/My-Blog/issues/new" target="_blank">New Issues</a></p>
```

效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381352770/wm)

点击后就可以直接在项目中提交问题了。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381365331/wm)

# 测试

#### 下载并解压代码

本课程中所实现的源码已经提供，所以直接下载到咱们实验楼的线上环境中即可，下载成功后执行 unzip 命令将项目解压：

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-29.zip
unzip My-Blog-29.zip
```

之后就能够看到咱们的项目了，过程如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381459557/wm)

# 线上环境中启动 Spring Boot 项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到 My-Blog 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 `mvn spring-boot:run` ，之后就可以等待项目启动。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381471087/wm)

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果。

之后会在浏览器中弹出 `https://********.simplelab.cn` 页面，我们可以在浏览器中随便输入一个错误地址进行验证，比如我们在访问详情页面时故意将地址栏中的 id 输错，果然得到了错误页面，最终得到的结果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381484235/wm)

本次实验完成！