* 《[用Markdown来写自由书籍-开源技术的方案](http://www.ituring.com.cn/article/828)》
* [简书](http://www.jianshu.com/) —— 使用MarkDown来写文章和博客。
* https://github.com/k2052/markdown-to-ebook


## 代码块

```java
public class Demo {
    public static void main(String[] args) {
        System.out.println("hello world");
    }
}
```

内容包含三个反引号时，外围需要使用四个反引号，或者三个波浪号。

~~~md
下面是markdown内嵌mermaid示例：
```mermaid
graph TD
    A[发现扩容后公网流量激增] --> B{OS层面定位}
    B --> C[ss/netstat 找 PID 和远程IP]
    C --> D[tcpdump 抓包分析协议和内容]
    D --> E{确定是 Java 进程}
    E --> F[JVM层面定位]
    F --> G[jstack 抓取线程栈, 找网络IO线程]
    F --> H[Arthas trace 监控方法调用]
    G & H --> I[定位到具体代码行/类]
    I --> J[分析原因: 定时任务? 配置错误? 重试风暴?]
    J --> K[修复代码/配置 + 紧急限流]
```
~~~

````md
下面是markdown内嵌mermaid示例：
```mermaid
graph TD
    A[发现扩容后公网流量激增] --> B{OS层面定位}
    B --> C[ss/netstat 找 PID 和远程IP]
    C --> D[tcpdump 抓包分析协议和内容]
    D --> E{确定是 Java 进程}
    E --> F[JVM层面定位]
    F --> G[jstack 抓取线程栈, 找网络IO线程]
    F --> H[Arthas trace 监控方法调用]
    G & H --> I[定位到具体代码行/类]
    I --> J[分析原因: 定时任务? 配置错误? 重试风暴?]
    J --> K[修复代码/配置 + 紧急限流]
```
````




## PlantUML

[PlantUML](https://plantuml.com/zh/)

```plantuml
@startuml firstDiagram

Alice -> Bob: Hello
Bob -> Alice: Hi!

@enduml
```


