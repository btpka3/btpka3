# 概念
双亲委派
- 找类: 优先从父 classLoader 找
- 加载: 优先从父 classLoader 加载，加载不到再从自己找

# 通用

```plain

BootstrapClassLoader            # 加载 jvm核心类，比如 ${JRE_HOME}/lib/ 下的 jar，比如：rt.jar,resoures.jar, charasets.jar 等
  - ExtentionClassLoader        # 加载 ${JRE_HOME}/lib/ext/ 下的 jar 包
    - ApplicationclassLoader    # 加载当前classPath下所有类

```

# tomcat
- Apache Tomcat 9 : [Class Loader How-To](https://tomcat.apache.org/tomcat-9.0-doc/class-loader-howto.html)


CommonClassLoader               # tomcat通用类加载器：加载 ${catalina.base}/lib、${catalina.home}/lib 下的jar
SharedClassLoader               # tomcat共享类加载器：多个war包共享的类，由 conf/catalina.properties 中的 shared.loader 指定
CatalinaClassLoader             # tomcat
CatalinaClassLoader             #
WebAppClassLoader


```plain
       Bootstrap
          |
      Extention
          |
         Common
          /    \
      Server   Shared
                /    \
            WebApp1  WebApp2
```


# pandora

- LaunchedURLClassLoader  #
- ModuleClassLoader      # pandora 的插件模块的classloader，负责隔离加载各个pandora插件下的类
- ReLaunchMainLauncher   #



```plain
                  Bootstrap
                   /    \                             \              \
         Application   PandoraContainerClassLoader    Module1(HSF) Module1(Metaq)
            |
            |
            |
    ReLaunchURLClassLoader   # 使用了 PandoraContainerClassLoader暴露的 classCache  ,
            |                # 起独立线程运行，使用该classLoader, 并运行 spring
            |
            |
    SpringBootApplicaiton#main

```




# Class#getDeclaredMethods 会触发 代码中 throw 的class 的类加载

```java
package com.alibaba.security.gong9.mw.commons.utils;

import com.alibaba.security.gong9.mw.commons.Gong9MwException;

/**
 * @author dangqian.zll
 * @date 2023/7/3
 */
public class Aaa {

    public void sayHi() {
        TcclUtils.withTccl(() -> {
            throw new Gong9MwException("aaa", "aaa");
        });
    }
}
```

```java
package com.alibaba.security.gong9.mw.commons.utils;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

public class ClassLoaderTest {

    /**
     * 指定 jvm 参数： -verbose:class 并运行。
     */
    @Test
    public void testClassLoad01() {
        System.out.println("-------------------------- 1");
        // Aaa class 将会在此时被触发加载，但内部使用到的 TcclUtils, Gong9MwException 此时不会被触发加载
        Aaa o = new Aaa();
        System.out.println("-------------------------- 2");
        // 当使用反射获取相关声明的方法时，此时会触发 Gong9MwException 的类加载，但不会触发 TcclUtils 的类加载。
        Method[] methods = o.getClass().getDeclaredMethods();
        System.out.println("-------------------------- 3");
    }
}
```
