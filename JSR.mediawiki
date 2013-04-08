==JSR 308: Annotations on Java Types==
从JDK 1.5 引入，追加了Annotation这一个概念，注解可以设置保留到什么阶段（编译时、运行时）等，提供一些额外的描述。个人感觉是copy自C#。
参考
* [http://jcp.org/en/jsr/detail?id=308 JSR 308]
* [http://www.infoq.com/cn/news/2008/05/JSR-308 JSR 308：Java语言复杂度在恣意增长？]

==JSR 305 - Annotations for Software Defect Detection==
被设计用于代码的静态bug检测。但是该项目目前处于休眠状态。
类似的静态检测用的注解，不同的工具也各自有注解。

总结：
* 各个不同版本的注解使用时依赖于特定的IDE和工具，在当今都使用Maven的时候，需要搜索并配置各自的Maven 插件。
* 只能在编译时进行检查（正确么？），如果某个使用者没有启用检查，仍然会抛出空指针异常。
* 建议：配合某种注解，并使用类似于<code>org.springframework.util.Assert</code>在代码中明确进行空判断？

部分API列表：
<source>
// JSR 305
javax.annotation.Nonnull
javax.annotation.Nullable

// FindBugs - 也支持 JSR 305?
edu.umd.cs.findbugs.annotations.NonNull

// IntelliJ IDEA IDE - 也支持 JSR 305?
com.intellij.annotations.NotNull

// Eclipse - 但是支持自定替换
org.eclipse.jdt.annotation.Nullable
org.eclipse.jdt.annotation.NonNull
org.eclipse.jdt.annotation.NonNullByDefault
</source>

参考：
* [http://help.eclipse.org/juno/index.jsp?topic=%2Forg.eclipse.jdt.doc.user%2Ftasks%2Ftask-using_null_annotations.htm Eclipse : Using null annotations]
* [http://stackoverflow.com/questions/4963300/which-notnull-java-annotation-should-i-use 在stackoverflow上的讨论]




==JSR 303 - Bean Validation==
主要用于运行时的检查，而不是静态分析。
部分API列表：
<source>
javax.validation.constraints.Max;
javax.validation.constraints.Min;
javax.validation.constraints.NotNull;
javax.validation.constraints.Pattern;
javax.validation.constraints.Size;
</source>

==JSR 350: Java State Management==
部分API列表：
<source>
javax.annotation.security.DeclareRoles
javax.annotation.security.DenyAll
javax.annotation.security.PermitAll
javax.annotation.security.RolesAllowed
javax.annotation.security.RunAs
javax.annotation.Generated
javax.annotation.PostConstruct
javax.annotation.PreDestroy
javax.annotation.Resource
javax.annotation.Resources
</source>
