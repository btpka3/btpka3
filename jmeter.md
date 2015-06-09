

# 安装Jemter
请参考nala-mobile工程 [test/jmeter/README.md](http://git.lizi.com/pd/nala-mobile/tree/public/test/jmeter)


# 使用 Groovy 类型的  BSF Sampler、PostProcessor、Assertion等
1. 需要从 GRAILS安装目录中将 groovy-all-*.jar 拷贝到 JMETER/lib 目录下。

    ```
    locate -r groovy-all*.jar
    cp /path/to/groovy-all*.jar ${JMETER_HOME}/lib
    ```
2. 然后参考官方文档[BSF Sampler](http://jmeter.apache.org/usermanual/component_reference.html#BSF_Sampler)、
[BSF PostProcessor](http://jmeter.apache.org/usermanual/component_reference.html#BSF_PostProcessor)、
[BSF Assertion](http://jmeter.apache.org/usermanual/component_reference.html#BSF_Assertion)等。
以便了解其中的预变量。
3. 需要手动在命令行下启动jemeter，以便能在控制台中看到console输出
4. 编写相应的groovy代码，可以使用groovy的println在控制台输出一些调试信息。比如Jemeter预订变量的具体类型信息，然后再参考JMeter的[javadoc](http://jmeter.apache.org/api/index.html)。


## 示例
对一个HTTP Sample的BSF PostProcessor的处理示例。

|预定义变量|java类|说明 |
|---------|-----------|---|
|log| [org.apache.log.Logger](http://excalibur.apache.org/apidocs/org/apache/log/Logger.html)||
|Label|||
|Filename|||
|Parameters|||
|args|||
|ctx |||
|vars |||
|props |||
|prev|[ org.apache.jmeter.protocol.http.sampler.HTTPSampleResult](http://jmeter.apache.org/api/org/apache/jmeter/protocol/http/sampler/HTTPSampleResult.html)|sampler的执行结果|
|sampler|||
|OUT|||