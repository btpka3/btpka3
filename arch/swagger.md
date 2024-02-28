

- [OpenAPI Specification v3.1.0](https://spec.openapis.org/oas/v3.1.0)
- [springdoc-openapi](https://springdoc.org/)


#swagger

[swagger](http://swagger.io) 定了一个类似 WSDL (描述 基于SOAP/XML格式的
WebService 语言)的API [描述语法](https://openapis.org), 但是其主要用来描述 RESTFul 风格的 API,
响应通常是JSON,而非XML。如果请求是POST, 请求内容通常是是 `application/x-www-form-urlencode` 格式。

而作为API实现者,通常只需要在代码仓库中按照格式编写一个API描述文档。
比如 [YAML格式](http://petstore.swagger.io/v2/swagger.yaml)
或 [JSON格式](http://petstore.swagger.io/v2/swagger.json)

该API描述文档可以使用 swagger-editor 进行编辑和简单的测试。如果仅仅是查看,
则可以使用 swagger-ui。

API 描述文档最好放在一个文件中, 可能人git协作编辑易产生冲突。但是如果分开存放,
则可能需要的额外工作量：

* 自己定义所有API的索引/导航画面。
* (每个API文件都需)定义api 主机，token等
*（部分相关的API文档中重复）定义相同的model。


# swagger-ui


仅仅提供了一个组零依赖的静态文件, 直接访问即可。
[github仓库](https://github.com/swagger-api/swagger-ui)

```
npm install swagger-ui
open node_modules/swagger-ui/dist/index.html
```

# swagger-editor

[在线版](http://editor.swagger.io/#/)、[github仓库](https://github.com/swagger-api/swagger-editor)

```
# 安装方式1
docker pull swaggerapi/swagger-editor
docker run -p 80:8080 swaggerapi/swagger-editor

# 安装方式2
git clone --branch v2.10.4 --depth 1 https://github.com/swagger-api/swagger-editor/
cd swagger-editor
npm install
npm start
```



# 如何暴露私有仓库中的 API的YAML文件?

1. 开发人员正常push到gitlab私有仓库
2. gitlab按照私有仓库的WebHook配置，向特定URL推送消息（比如 http://ci.kingsilk.xyz/xxxxx)
3. jenkins 根据消息触发，执行特定任务：pull 最新代码本地磁盘
4. （一次性）nginx配置，“只”暴露API 描述文件（YAML/JSON) 到特定域名
5. API使用人员，打开 swagger-edior， swagger-ui，加载想要的API的YAML/JSON 文件 URL查看。

如果今后采用 swagger, 则：
1. api的javadoc中可以不用具体参数等细节
2. 原有markdown格式的文件都不需要了，可以逐步迁移为YAML文件。


# FIMXE

[如何分割?](http://azimi.me/2015/07/16/split-swagger-into-smaller-files.html)


# swagger-codegen

```bash
# mac / linux install
brew install swagger-codegen

# 查看帮助
swagger-codegen help

swagger-codegen help generate

# 查看特定语言的配置项
swagger-codegen config-help -l javascript-closure-angular


swagger-codegen generate \
    -i http://petstore.swagger.io/v2/swagger.json \
    -l javascript-closure-angular \
    -DappName=zll \
    -c config.json


-DuseEs6=true
```

