# JDK
## [jstat](http://docs.oracle.com/javase/6/docs/technotes/tools/share/jstat.html)
### 使用方法

```sh
zll@zll-pc:bin$ jstat -help
Usage: jstat -help|-options
       jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]
```

### 选项列表

```sh
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
```sh
zll@zll-pc:bin$ jstat  -gcutil 22679 
  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT   
  0.00  99.17  75.12  68.32  57.97     21    1.099     2    1.253    2.352
```

### -class 
Class加载状况统计
```sh
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
```sh
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
```sh
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

```sh
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
[java JVM 内存类型](http://javapapers.com/core-java/java-jvm-memory-types/)

[2](https://blogs.oracle.com/jonthecollector/entry/presenting_the_permanent_generation)