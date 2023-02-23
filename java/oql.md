Object Query Language

- [MemoryAnalyzer/OQL](https://wiki.eclipse.org/MemoryAnalyzer/OQL)
- [Object Query Language (OQL)](https://cr.openjdk.java.net/~sundar/8022483/webrev.01/raw_files/new/src/share/classes/com/sun/tools/hat/resources/oqlhelp.html#:~:text=Object%20Query%20Language%20%28OQL%29%20OQL%20is%20SQL-like%20query,allows%20to%20filter%2Fselect%20information%20wanted%20from%20Java%20heap.)
- [org.eclipse.mat.parser.model.InstanceImpl](https://help.eclipse.org/latest/index.jsp?topic=%2Forg.eclipse.mat.ui.help%2Fdoc%2Forg%2Feclipse%2Fmat%2Fparser%2Fmodel%2FInstanceImpl.html)
- [Memory Analyzer > Reference > OQL Syntax > Property Accessors : Built-in OQL functions](https://help.eclipse.org/latest/index.jsp?topic=%2Forg.eclipse.mat.ui.help%2Fconcepts%2Fdominatortree.html)
- java.lang.ref.Finalizer
- [JVM垃圾回收的java.lang.ref.Finalizer](https://blog.csdn.net/u014365523/article/details/127513012)
- [How to Handle Java Finalization's Memory-Retention Issues](https://www.oracle.com/technical-resources/articles/javase/finalization.html)
- [A Guide to the finalize Method in Java](https://www.baeldung.com/java-finalize)
- [finalize method in java - 13 salient features, force jvm to run garbage collection](https://www.javamadesoeasy.com/2015/05/finalize-method-in-java-10-salient.html)
- [Guide to the Most Important JVM Parameters](https://www.baeldung.com/jvm-parameters)
- [开启String去重XX:+UseStringDeduplication的利与弊](https://blog.csdn.net/Dongguabai/article/details/114391877)

```sql
select s.@outboundReferences from java.io.FileOutputStream s where s.fd.fd=142

select inbounds(s) from java.io.FileOutputStream s where s.fd.fd=142

```


# 内建函数
- outbounds( object ) : 查询出给定对象引用的所有对象
- inbounds( object ) : 查询出哪些对象应用了给定的对象
- dominators( object ) : 查询出给定对象 直接持有的 对象列表
- dominatorof( object ) : 查询出哪些对象直接持有给定的对象
