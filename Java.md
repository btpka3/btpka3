# JDK
## jstat
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
-gcutil                       # 常用
-printcompilation
```
### 示例
```sh
zll@zll-pc:bin$ jstat  -gcutil 22679 
  S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT   
  0.00  99.17  75.12  68.32  57.97     21    1.099     2    1.253    2.352
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