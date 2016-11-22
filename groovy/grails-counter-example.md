
该wiki将追加一些常见变成错误。


# 关于日志

1. 如果有大计算量、内存消耗的信息需要向、且只向日志中输出，需要条件输出。

    ```groovy
    // 反例
    def xxx=[]                    // 假设该变量仅仅在在日志中输出，其他地方不使用
    yyyList.each{xxx.add("...")}  // 大量消耗内存，消耗CPU
    log.debug(yyyList)            // 有可能在生产环境因为禁用debug级别，造成上述操作完全无用

    // 应当
    if(log.isDebugEnabled()){     // 先判断日志级别
        def xxx=[]
        yyyList.each{xxx.add("...")}
        log.debug(yyyList)
    }
    ```

1. 向日志中输出异常信息。

    ```groovy
    // 反例
    try {
        // ...
    } catch (XxxException e){
        // ...
        log.error(e)                         // 会仅仅打印出错误消息，而缺少堆栈信息
        log.error(e.getMessage())            // 会仅仅打印出错误消息，而缺少堆栈信息
        log.error(e.printStackTrace())       // 会打印出堆栈信息到控制台，但日志文件仅仅是一个空行。线上环境因为不开启控制台而会丢失堆栈信息
        log.error("..." + e.getMessage())    // 会仅仅打印出错误消息，而缺少堆栈信息
    }

    // 应当
    try {
        // ...
    } catch (XxxException e){
        // ...
        log.error(e.getMessage(), e)
        log.error("...", e)
    }
    ```

# 关于GSP

1. 针对站内连接，不要硬编码写链接地址，哪怕根据SEO建议也写完整的URL地址，应使用`<g:createLink>`、`<g:resource/>`。

    ```html
    // 反例
    <a href="/xxx/yyy">...</a>
    <a href="http://www.lizi.com/product-458695865.html">...</a>
    <script src="/js/xxx.js"></script>

    // 应当
    // 先在 Config.groovy 中设置 grails.serverURL，再修改GSP文件
    <a href="${createLink(controller:'item', action:'show', params:[k1:v1,k2:v2], absolute:true)}">...</a>
    <script src="${resource(dir: 'js', file: 'xxx.js', absolute:true)}"></script>
    ```
1. render之后不应该有任何其他语句。如果在 `if...else...` 或者 循环等分支中出现了 render 语句，则之后一定要有个return语句。


# 关于GORM

1. 需要部分查询时，一定要设置一个合理的最大记录数。
   ```groovy
    // 反例
    def list = Item.createCriteria().list() {           // 没有设置返回的最大记录数 max
        "in"('status', [ItemStatusEnum.SHANGJIA, ItemStatusEnum.ESHORT])
    }
    // 直接使用Controller的params Map，可能会没有max参数，也可能有额外参数操作出错
    def list = Item.createCriteria().list(params) {
        "in"('status', [ItemStatusEnum.SHANGJIA, ItemStatusEnum.ESHORT])
    }

    // 应当
    def list = Item.createCriteria().list(max:10) {              // 明确指明max值，或检查后给予个合理值
        "in"('status', [ItemStatusEnum.SHANGJIA, ItemStatusEnum.ESHORT])
        maxResults(10)                                           // 同max参数
    }
    ```

1. 需要遍历全部、或者大量（比如超过100条）记录时，不要直接返回所有记录集，而是需要从数据库中读取一条记录，处理一条记录，之后再读取一条记录，如此反复。

    ```groovy
    // 反例
    def list = CmsPageView.executeQuery("...")
    def list = CmsPageView.createCriteria.list { /* ...*/}

    // 应当 ： createCriteria 示例
    def results = CmsPage.createCriteria().scroll() {
        fetchSize(Integer.MIN_VALUE) // 每次预读取多少条记录，但由于MySql实现的特殊性，只能设置为该值后才能一条一条的读取
        maxResults(1000)             // 如果只是部分记录的话，可以限定记录数
        readOnly(true)               // 如果只读的话
        // ...
    }
    while(results.next()){
        CmsPage cmsPage = results.get(0)
        // ...
    }

    // 应当 ： HQL 示例
    //（通常用在createCriteria无法处理的情形，比如 having 操作）
    CmsPageView.withSession {Session session->
        def results = session.createQuery("" +
                    "select date, cmspage.id " +
                    "from CmsPageView " +
                    "group by date, cmspage.id " +
                    "having count(*)>1 " +
                    "order by date asc, cmspage.id asc")
                    .setFetchSize(Integer.MIN_VALUE)         // MySql 特殊
                    .scroll()
        while (results.next()) {
            def row = results.get()
            println(Arrays.asList(row))
        }
    }

    // 应当 ： SQL 示例
    //（通常用在createCriteria无法处理的情形，比如 having 操作）
    CmsPageView.withSession {Session session->

        def sql = """
      select date, cmspage_id
        from cms_page_view
       where date_created > ?
    group by date, cmspage_id
      having count(*) > 1
    order by date asc, cmspage_id asc
    """
        def sqlParams = []
        def query = session.createSQLQuery(sql)
        for(int i = 0; i < sqlParams.size(); i++){           // 设置参数
            query.setParameter(i, sqlParams.get(i)
        }

        def results = query
                .setFetchSize(Integer.MIN_VALUE)             // MySql特殊
                .scroll()
        while (results.next()) {
            def row = results.get()
            println(Arrays.asList(row))
        }
    }
    ```

    注意：MySQL有特殊性，用scroll方法时，有一些约束：
    * 必须设置fetchSize=Integer.MIN_VALUE，否则仍会一次性把所有记录集加载到内存中的。
    * 没有遍历完结果集时，在当前jdbc connection上无法进行任何sql操作。（比如，Hibrenate的关联对象的延迟读取）

    如果不能满足上述约束，建议使用日期，或者SQL的offset+limit循环地、小批量的进行处理（该小批量数据会一次性全部读取到内存中）

1. 清空一对多

    假设 user hasMany Order, 并且是在多的一侧（order）中追加user字段做关联

    ```
    // 清空
    user.orders.each { order ->
        order.delete()
    }
    user.orders.clear()  // 一定要有此句

    // 添加
    user.addToOrders(new Order())
    ```


# 关于 application/x-www-form-urlencoded

1. MultiValueMap -> String

    ```groovy
    MultiValueMap reqMsg = new LinkedMultiValueMap()
    reqMsg.schema = "xxx";
    reqMsg.param = "a\"b中国c"
    HttpOutputMessage outMsg = new MockHttpOutputMessage()

    HttpMessageConverter httpMsgConverter = new FormHttpMessageConverter()
    httpMsgConverter.setCharset(Charset.forName("UTF-8"))        // 明确指明使用 UTF-8 进行进行URLEncoding
    httpMsgConverter.write(reqMsg, MediaType.APPLICATION_FORM_URLENCODED, outMsg)
    return outMsg.getBodyAsString()
    ```
1. String -> MultiValueMap

    ```
    MultiValueMap reqMsg = UriComponentsBuilder.newInstance()
            .query("a=a1&a=a2&b=bbb")
            .build()
            .getQueryParams()
    ```


# 关于 application/xml

1. XML -> String

    ```groovy
    def writer = new StringWriter()
    def xml = new MarkupBuilder(writer)
    xml.mkp.xmlDeclaration(version: '1.0', encoding: "UTF-8")
    xml.rootNode() {
        node1(a: "a")
        2.times {
            node2(attr1: 'value1', attr2: "value2") {
                emptyNode(attr3: "value3")
            }
        }
    }
    String xmlStr = writer.toString()
    render(contentType: "application/xml", text: xmlStr)
    ```
1. String -> XML

    ```groovy
    // 1. 使用XmlParser
    String xmlStr = ...
    def rootNode = new XmlParser().parseText(xmlStr)
    def node2Count = rootNode.node2.size()
    def attrValue = rootNode.node2[0].'@attr1'

    // 2. 使用 grails.converters.XML
    String xmlStr = ...
    def xmlObj = XML.parse(xmlStr)

    // 3. 使用 grails.converters.XML
    GPathResult xml = request.XML
    new XmlUtil().serialize(xml, System.out)
    ```


# 关于 application/json

1. Map -> JSON -> String
    ```groovy
    // 1. 使用Map+JsonBuilder。
    def jsonMap = [
            attr1 : 1,
            attr2 : [1,"2",3]
    ]
    jsonMap.attr3 = "3"
    jsonMap.attr4 = [
            attr41 : 41,
            attr42 : "42"
    ]
    def jsonStr = new JsonBuilder(jsonMap).toString()

    // 2. 使用JsonBuilder
    // 注意：该方法输出的JSON中的特殊字符、汉字等都会进行unicode转义，比如 "中文" -> "\u4E2D\u6587"
    //      微信相关的API会报错，请参考下面的例子直接使用Jackson2
    def builder = new JsonBuilder()
    builder {
        person {
            firstName 'Guillame'
            address(
                    city: 'Paris',
                    country: 'aaa<>"\'&中文bbb',
                    zip: 12345,
            )
        }
    }
    def jsonStr = builder.toString()

    // 3. 直接使用 Jaskson2 : map -> json string
    // 该方式，默认是没有进行unicode转义的。但可以配置
    // 注意：由于JsonBuilder内部也是先构建map的，所以可以它的DSL来简化map的生成，最后使用 builder.getContent() 获取 map。
    def builder = new JsonBuilder()
    builder {
        country: 'aaa<>"\'&中文bbb'
    }
    def jsonStr = new ObjectMapper().writeValueAsString(builder.getContent());  // builder.getContent() 是 map类型

    // 4. 在Action中可以使用
    def map = ...
    render (map as JSON)
    ```

1. String -> JSON

    ```groovy
    // 1. 使用JsonSlurper
    def jsonStr =  "..."
    def jsonResult = new JsonSlurper().parseText(jsonStr)
    def value = jsonResult.attr1.attr11

    // 2. 使用 grails.converters.JSON
    def jsonStr =  "..."
    def jsonObject = JSON.parse(jsonStr)
    ```

# 关于HTTP请求

"application/x-www-form-urlencoded" 的定义在[这里](http://www.w3.org/TR/html401/interact/forms.html#didx-applicationx-www-form-urlencoded)。

```groovy
// 反例
// 1. 手动字符串拼接。该方式常常会忽略URL特殊字符和中文的转义。
// 2. 不推荐：使用各种自己编写的工具类——除非有什么特殊原因。
// 3. 不推荐：使用JDK自带的URLConnection或Apache HttpClient等API，因为接口过于低级。
// 4. FIXME ??? 不推荐：使用Grails REST Plugin、Groovy HTTPBuilder
// 5. 推荐：统一使用Spring提供的RestTemplate。原因：
//    * Java开发和Grails开发均可用
//    * API也很方便、简洁
//    * 可细颗粒度配置（比如中文编码等）
```

1. 拼接带有参数的URL

    ```groovy
    // 应当
    String url = "http://localhost:8080/lizi-tmp/{controller}/{action}.{format}?a=a1&b=b1"
    def map = [
            controller: "test",
            action    : "hi",
            format    : "json"
    ]
    URI uri = UriComponentsBuilder
            .fromHttpUrl(url)                    // 先使用一个模板创建UriComponentsBuilder
            .host("127.0.0.1")                   // 设置/替换其中的host
            .queryParam("a", "a2")               // 新增URL参数。注意：如果已有该参数，会继续添加，实际变成数组。
            .replaceQueryParam("b", "b2")        // 替换URL参数。可以多个值
            .queryParam("c", "c1中")             // 新增URL参数
            .queryParam("_{format}", "{format}") // 新增URL参数，注意：builder中的值和参数都允许使用变量
            .build()                             // -> UriComponents 。此时，尚未进行URL编码
            .expand(map)                         // 替换变量
            .encode("UTF-8")                     // 进行URL编码
            .toUri()                             // -> URI
    println uri  // http://127.0.0.1:8080/lizi-tmp/test/hi.json?a=a1&a=a2&b=b2&c=c1%E4%B8%AD&_json=json
    ```

1.  发送GET请求

    ```groovy
    // 应当：1. 发送GET请求，并获取字符串结果（无需处理请求头、响应头）
    URI url = ...
    String respStr = restTemplate.getForObject(url, String)

    // 应当：2. 发送GET请求，并获取字符串结果（无需处理请求头、但需要处理响应头）
    URI url = ...
    ResponseEntity respEntity = restTemplate.getForEntity(uri, String)
    String respStr = respEntity.getBody()

    // 应当：3. 发送GET请求，并获取字符串结果（需处理请求头）
    HttpHeaders headers = new HttpHeaders();
    headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
    HttpEntity<Void> reqEntity = new HttpEntity<Void>(null, headers);
    ResponseEntity respEntity = restTemplate.exchange(url, HttpMethod.GET, reqEntity, String.class);
    String respStr = respEntity.getBody()
    ```


1.  发送POST请求

    ```groovy
    // 应当：1. 发送POST请求，并获取字符串结果（无需处理请求头、响应头）
    // 请求body编码为："application/x-www-form-urlencoded"，默认使用UTF-8进行URL encoding
    URI url = ...
    MultiValueMap reqMsg = new LinkedMultiValueMap()
    reqMsg.key1 = "value1"
    reqMsg.key2 = "value2"
    String respStr = restTemplate.postForObject(url, reqMsg, String)

    // 应当：2. 发送POST请求，并获取字符串结果（无需处理请求头、但需要处理响应头）
    URI url = ...
    MultiValueMap reqMsg = new LinkedMultiValueMap()
    ResponseEntity respEntity = restTemplate.postForEntity(uri, reqMsg, String)
    String respStr = respEntity.getBody()

    // 应当：3. 发送POST请求，并获取字符串结果（需处理请求头）
    URI url = ...
    MultiValueMap reqMsg = new LinkedMultiValueMap()
    HttpHeaders headers = new HttpHeaders();
    headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
    HttpEntity<MultiValueMap> reqEntity = new HttpEntity<MultiValueMap>(reqMsg, headers);
    ResponseEntity respEntity = restTemplate.exchange(url, HttpMethod.POST, reqEntity, String.class);
    String respStr = respEntity.getBody()

    // 应当：4.
    // 如果需要发送XML，或JSON格式的请求，请使用String类型的reqMsg
    // 如果需要发送特定编码的字符串，请使用byte[]类型的reqMsg
    // 如果需要发送提定URL encoding编码的 "application/x-www-form-urlencoded"， 比如： "GBK"，请参考以下示例。
    //    但是，需要手动设置Content-Type请求头。
    String reqMsg = UriComponentsBuilder    // String类型默认由 StringHttpMessageConverter 按照 "ISO-8859-1" 编码发送
            .newInstance()                  // 但在后面调用 encode() 之后就全部为基本ASCII码，故无需担心。
            .queryParam("a", "a1","a2")
            .queryParam("c", "c1 中")
            .build()
            .encode("GBK")
            .query                          // a=a1&a=a2&c=c1%20%E4%B8%AD
    ```

# 关于 Async
Grails 在Controller中 Async 调用，必须阻塞请求，否则会出错。如果不想阻塞，请：

1. 请不要到用 Promise#onError、Promise#onError#onComplete 等方法传递在Controller中构造的 Closure。或者干脆不要调用。
1. 则考虑使用类似于JDK中的Executor之类的框架。

```groovy
class TestZllController {
    def async() {
        Promise p = Promises.task {
            Thread.sleep(10 * 1000)
           return "1111"
        }
        p.onError { Throwable err ->
            println "11111111111111111111 An error occured ${err.message}"
        }
        p.onComplete { result ->
            println "22222222222222222222 Promise returned $result"
        }
        println "33333333333" // + p.get()
        render("@@@")
    }
}
```

错误堆栈

```
2015-09-14 18:01:53,610 [ERROR][Actor Thread 9] org.grails.async.factory.gpars.LoggingPoolFactory - Async execution error: null
java.lang.NullPointerException
	at org.apache.catalina.connector.Request.notifyAttributeAssigned(Request.java:1498)
	at org.apache.catalina.connector.Request.setAttribute(Request.java:1488)
	at org.apache.catalina.connector.RequestFacade.setAttribute(RequestFacade.java:539)
	at javax.servlet.ServletRequestWrapper.setAttribute(ServletRequestWrapper.java:246)
	at javax.servlet.ServletRequestWrapper.setAttribute(ServletRequestWrapper.java:246)
	at javax.servlet.ServletRequestWrapper.setAttribute(ServletRequestWrapper.java:246)
	at org.codehaus.groovy.grails.web.util.WebUtils.storeGrailsWebRequest(WebUtils.java:431)
	at org.codehaus.groovy.grails.plugins.web.async.WebRequestPromsiseDecorator$_decorate_closure1.doCall(WebRequestPromiseDecoratorLookupStrategy.groovy:55)
	at org.codehaus.groovy.grails.plugins.web.async.WebRequestPromsiseDecorator$_decorate_closure1.call(WebRequestPromiseDecoratorLookupStrategy.groovy)
	at org.grails.async.factory.gpars.GparsPromise$_onError_closure2.doCall(GparsPromise.groovy:72)
	at org.grails.async.factory.gpars.GparsPromise$_onError_closure2.call(GparsPromise.groovy)
	at groovyx.gpars.dataflow.DataCallback$1.run(DataCallback.java:62)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
	at java.lang.Thread.run(Thread.java:745)
```

# Service 内访问 request， session

```groovy
GrailsWebRequest grailsReq = WebUtils.retrieveGrailsWebRequest()
HttpServletRequest httpReq = grailsReq.getCurrentRequest()
HttpSession httpSession = grailsReq.getSession()

RequestAttributes req = RequestContextHolder.currentRequestAttributes();
```

# 关于Grails异步编程 task

Grails 的异步编程 task 在当前请求返回response前，必须全部执行完，否则会引发多线程问题（比如，事务，cookie、session等问题）。
因为 grails task的实现，引用了 HttpServletRequest。
