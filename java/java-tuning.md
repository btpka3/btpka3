[CFR - another java decompiler](http://www.benf.org/other/cfr/)
[代码优化](http://kb.cnblogs.com/page/510538/)

# 线上环境

`-XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled`

```bash

today=`date +%Y%m%d%H%M%S`
export CATALINA_OPTS=" \
    -server \
    -Xms512m \
    -Xmx1024m \
    -XX:PermSize=32m \
    -XX:MaxPermSize=256m \
    -Dfile.encoding=UTF-8 \
    -Djava.net.preferIPv4Stack=true \
    -XX:ErrorFile=${CATALINA_HOME}/logs/hs_err_pid%p.log \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=${CATALINA_HOME}/logs/start.at.$today.dump.hprof \
    -XX:+UseConcMarkSweepGC \
    -XX:+PrintGCDateStamps \                                  
    -XX:+PrintGCDetails \
    -Xloggc:${CATALINA_HOME}/logs/start.at.$today.gc.log \
"
```

# 远程debug

```bash
#JDK 1.5+
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=10014

# JDK 1.4.x
-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=10014

# JDK 1.3 or earlier
-Xnoagent -Djava.compiler=NONE -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=10014
```

# 远程jvisualvm


参考[这里](http://ihuangweiwei.iteye.com/blog/1219302)
1. 新建 policy 文件 : jstatd.all.policy

    ```groovy
    grant codebase "file:${java.home}/../lib/tools.jar" {  
       permission java.security.AllPermission;  
    };  
    ```
1. 确保/etc/hosts 中主机名对应的是其他主机可以访问到的IP地址

    ```bash
    cat /etc/hosts
    192.168.101.81     s81
    ```

1. 运行 jstad

    ```bash
    jstatd -J-Djava.security.policy=/path/to/jstatd.all.policy  &
    ```

然后就可以在其他主机上使用jvisulavm 查看远程的java运行信息了。




HPROF or jhat 
http://publib.boulder.ibm.com/infocenter/realtime/v2r0/index.jsp?topic=%2Fcom.ibm.rt.doc.20%2Frealtime%2Fdiagnose_oom.html


# jstack



```bash
jstack <pid>
```
Java 线程 CPU 100% 对应方法

1. 通过 `top` 或者 `jps -mlv` 找到所需的 Java 进程的 pid1。
1. 通过 `top -p pid1 -H` 观则得到最占 CPU 的线程的 pid2。. 
1. `jstack pid1 > cpu.log`
1. `vi cpu.log` 并用 pid2 查找所需的线程堆栈，然后分析代码。



# JDK

## jinfo
可以输出并修改运行时的java 进程的opts。

##jps
与unix上的ps类似，用来显示本地的java进程，可以查看本地运行着几个java程序，并显示他们的进程号。

```bash
jps -mlv
```


##jmap
打印出某个java进程（使用pid）内存内的所有'对象'的情况（如：产生那些对象，及其数量）。

```bash
jmap -dump:format=b,file=outfile.jmap.hprof 3024
```
如果报以下错误，请确认启用jmap的用户是否和目标java进程是同一个用户，否则追加参数 -F 尝试。

```
Unable to open socket file: target process not responding or HotSpot VM not loaded
The -F option can be used when the target process is not responding
```

##jconsole
一个java GUI监视工具，可以以图表化的形式显示各种数据。并可通过远程连接监视远程的服务器VM。 

## [jstat](http://docs.oracle.com/javase/6/docs/technotes/tools/share/jstat.html)
可以用来监视VM内存内的各种堆和非堆的大小及其内存使用量
### 使用方法

```bash
zll@zll-pc:bin$ jstat -help
Usage: jstat -help|-options
       jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]
```

### 选项列表

```bash
zll@zll-pc:bin$ jstat -options
-class
-compiler
-gc
-gccapacity
-gccause
-gcnew
-gcnewcapacity
-gcold
-gcoldcapacity
-gcpermcapacity
-gcutil
-printcompilation
```
### 示例
```bash
zll@zll-pc:bin$ jstat  -gcutil 22679 
  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT   
  0.00  99.17  75.12  68.32  57.97     21    1.099     2    1.253    2.352
```

### -class 
Class加载状况统计
```bash
zll@zll-pc:bin$ jstat -class 18904
Loaded  Bytes  Unloaded  Bytes     Time   
  5784 11346.6        0     0.0       9.37

Loaded             # 载入的Class的数量
Bytes              # 载入的Class的字节数（kb）
Unloaded           # 卸载的Class的数量
Bytes              # 卸载的Class的字节数（kb）
Time               # 载入和卸载Class所消耗的时间
```
### -compiler
HotSpot Just-In-Time 编译器统计
```bash
zll@zll-pc:bin$ jstat -compiler 18904
Compiled Failed Invalid   Time   FailedType FailedMethod
    1464      1       0    41.96          1 com/alibaba/dubbo/config/spring/schema/DubboBeanDefinitionParser parse

Compiled           # 进行编译任务的数量
Failed             # 失败的编译任务数量
Invalid            # 无效的编译任务的数量
Time               # 编译消耗的时间
FailedType         # 最后一次编译失败的类型
FailedMethod       # 最后一次编译失败的类和方法
```

### -gc
垃圾回收堆的统计
```bash
zll@zll-pc:bin$ jstat -gc 18904
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       PC     PU    YGC     YGCT    FGC    FGCT     GCT   
8192.0 11264.0 8006.2  0.0   458752.0 117275.1  62976.0    42636.1   35840.0 35716.6     18    0.483   0      0.000    0.483

S0C                # 
S1C    
S0U    
S1U      
EC       
EU        
OC         
OU       
PC     
PU    
YGC     
YGCT    
FGC    
FGCT     
GCT 
```



### 字段说明

```bash
S0       # Heap上的 Survivor space 0 区已使用空间的百分比
S1       # Heap上的 Survivor space 1 区已使用空间的百分比
E        # Heap上的 Eden space 区已使用空间的百分比
O        # Heap上的 Old space 区已使用空间的百分比
P        # Perm space 区已使用空间的百分比
YGC      # 从应用程序启动到采样时发生 Young GC 的次数
YGCT     # 从应用程序启动到采样时 Young GC 所用的时间(单位秒)
FGC      # 从应用程序启动到采样时发生 Full GC 的次数
FGCT     # 从应用程序启动到采样时 Full GC 所用的时间(单位秒)
GCT      # 从应用程序启动到采样时用于垃圾回收的总时间(单位秒)
```

## 远程调试
```
java -Dcom.sun.management.jmxremote.port=3333 \
     -Dcom.sun.management.jmxremote.ssl=false \
     -Dcom.sun.management.jmxremote.authenticate=false \
     -Djava.rmi.server.hostname=10.1.10.104\
     YourJavaApp
```


## 开发用信任证书
```
java -Djavax.net.ssl.trustStore=/path/to/your.keystore\
     -Djavax.net.ssl.trustStorePassword=123456\
     YourJavaApp
```


# 内存管理
[Memory Management in the Java HotSpotTM Virtual Machine](http://www.oracle.com/technetwork/java/javase/memorymanagement-whitepaper-150215.pdf)



[java JVM 内存类型](http://javapapers.com/core-java/java-jvm-memory-types/)

[presenting the permanent generation](https://blogs.oracle.com/jonthecollector/entry/presenting_the_permanent_generation)

[JVM Options](http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html)

[gc tuning](http://www.oracle.com/technetwork/java/gc-tuning-5-138395.html)

[Garbage First](http://www.oracle.com/technetwork/java/javase/tech/g1-intro-jsp-135488.html)

[jdk 1.7 - java](http://docs.oracle.com/javase/7/docs/technotes/tools/windows/java.html)


## 内存分类
* HEAP ： 存储对象、数组，又称为共享内存——多个线程共享该内存。
* NON-HEAP
    * Method Area : 
        * 存储每个类的结构（比如：运行时常量、静态变量）、
        * method和构造函数的代码。
        * 运行时常量池（Runtime Constant Pool），每个class、interface都有。
    * ？？？ Stack : 对线程私有，以栈的方式存储立即数，对象的地址，返回值，异常。
    * other
## 内存管理
是按照内存池进行管理。可能属于heap或non-heap。


## 垃圾回收是按照
* Yong generation
    * Eden
    * survivor x 2
* Old generation
    * Tenured : 新生代中经过多轮垃圾回收仍在幸存区的数据会转移至此。
    * PermGen （Permanent generation）: 存储JVM的元数据，比如类对象，方法对象（注意：是“对象”，区别与method area的code--字节码）
