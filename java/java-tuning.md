

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

```bash
java \
    -Djava.rmi.server.hostname=192.168.200.136 \
    -Dcom.sun.management.jmxremote.port=18888 \
    -Dcom.sun.management.jmxremote=true \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Dcom.sun.managementote.ssl=false \
    -Dcom.sun.management.jmxremote.authenticate=false 
    ...

jvisualvm  # 连接 192.168.200.136:18888
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

## jps
与unix上的ps类似，用来显示本地的java进程，可以查看本地运行着几个java程序，并显示他们的进程号。

```bash
jps -mlv
```


## jmap
打印出某个java进程（使用pid）内存内的所有'对象'的情况（如：产生那些对象，及其数量）。

```bash
jmap -heap      xxxPid  # 打印 使用的垃圾回收器，heap 的配置和使用状况
jmap -histo     xxxPid  # 打印 各个类实例对象使用内存的柱状图（histogram）

# dump出内存
jmap -dump:format=b,file=outfile.jmap.dump.hprof 3024
```
如果报以下错误，请确认启用jmap的用户是否和目标java进程是同一个用户，否则追加参数 -F 尝试。

```
Unable to open socket file: target process not responding or HotSpot VM not loaded
The -F option can be used when the target process is not responding
```

## jconsole
一个java GUI监视工具，可以以图表化的形式显示各种数据。并可通过远程连接监视远程的服务器VM。

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


# 参考

- [Java HotSpot Garbage Collection](http://www.oracle.com/technetwork/java/javase/tech/index-jsp-140228.html)
    - [Memory Management in the Java HotSpotTM Virtual Machine](http://www.oracle.com/technetwork/java/javase/tech/memorymanagement-whitepaper-1-150020.pdf)
    - [Garbage Collection Tuning](http://www.oracle.com/technetwork/java/javase/gc-tuning-6-140523.html)
    - [gc tuning](http://www.oracle.com/technetwork/java/gc-tuning-5-138395.html)
    - [Garbage First](http://www.oracle.com/technetwork/java/javase/tech/g1-intro-jsp-135488.html)
    - [Getting Started with the G1 Garbage Collector](http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/G1GettingStarted/index.html)
- [jdk 9](https://docs.oracle.com/javase/9/index.html)
- [jdk 1.7 - java](http://docs.oracle.com/javase/7/docs/technotes/tools/windows/java.html)
- [JVM Options](http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html)
- [CFR - another java decompiler](http://www.benf.org/other/cfr/)
- [presenting the permanent generation](https://blogs.oracle.com/jonthecollector/entry/presenting_the_permanent_generation)
- [代码优化](http://kb.cnblogs.com/page/510538/)

![JVM 关键组件](http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/G1GettingStarted/images/gcslides/Slide2.png)

```text
Young Generation = Eden + Survivor * 2 。 // Suvivor named 'From', 'To'
Old Generation 

- Young Generation 满了？From 中已经有数据了。触发 young generation collection /minor collection
    - From 中要保留的对象足够老？
      Yes - copy 到 Old 中
      No  - copy 到 To  中，To 不能能放的下？直接放到 Old 中。
    - Young 中的要保留的对象 copy 到 To 中。对象太大，放不下？否则直接放到 Old 中
    - 如果 copy 到 To 时，To已经满了，则 Eden 和 From 剩余所有存活对象都要 copy 到 Old 中。
- Old 也满了？则触发  full collection/major collection。执行 mark-sweep-compact
```


## 内存分类
* HEAP ： 存储对象、数组，又称为共享内存——多个线程共享该内存。
* NON-HEAP
    * Method Area :
        * 存储每个类的结构（比如：运行时常量、静态变量）、
        * method和构造函数的代码。
        * 运行时常量池（Runtime Constant Pool），每个class、interface都有。
    * ？？？ Stack : 对线程私有，以栈的方式存储立即数，对象的地址，返回值，异常。
    * other

## 垃圾回收机制

### 垃圾回收器的性能指标


### 分类

- Serial Collector 
 
   单线程执行，stop-the-world, 对 Old generation，执行 mark-sweep-compact
   何时使用? Jvm运行在 client 模式，且对全局暂停时间不敏感。
   如果是 JDK5 且运行在 client 模式，会默认是该垃圾回收机制。
   可以通过 `-XX:+UseSerialGC` 手动启用。

- Parallel Collector/throughput collector
    
    多线程执行，仍然要 stop-the-world, 但是因为是多线程执行，可以大大缩小 全局冻结时间。
    可以避免在垃圾回收时，只有一个CPU在工作，其他CPU都处于空闲等待状态。
    何时使用？JVM 运行在多核CPU上，且对全局暂停时间不敏感。
    因为有可能全局暂停时间仍然会很长，也有可能会造成 old generation collection。
    注意：该垃圾回收机制仅工作于 Yong generation. 
    对于 Old generation，仍然使用 Serial Collector。
    
    如果是 JDK5 且运行在 server 模式，则默认会使用该模式。
    可以通过 `-XX:+UseParallelGC` 手动启用。
    
    ```text
    # Serial Collector
    ---->|            |---->
    ---->|===========>|---->
    ---->|            |---->
  
    # Parallel Collector
    ---->|===>|---->
    ---->|===>|---->
    ---->|===>|---->
    ```    

- Parallel Compacting Collector
 
    同 `Parallel Collector` 的区别就是，该模式
    对于 Young generation, 其算法与 Parallel Collector 一致。
    对于 Old generation/Permanent generation : stop-the-world, 多线程执行。
    
    - marking 阶段：多线程并发执行，将内存分成固定区块，标记其中要清除的对象
    - summary 阶段：单线程执行，按固定区块检查，找到一个分界点，一边是有很多存活对象的，一边是要清空的。
    - compaction 阶段：多线程执行，根据总结的信息，并发执行。
    
    何时使用？运行在多核CPU上，且对全局冻结时间敏感。
    但不适用于共享虚拟机——即无法保障能独占CPU一段时间，这种情况，
    可以使用 `–XX:ParallelGCThreads=n` 来减少 GC 线程数，或选择其他垃圾回收器。

    可以通过 `-XX:+UseParallelOldGC` 手动启用。

- Concurrent Mark-Sweep (CMS) Collector/low-latency collector
    
    有时候，端到端的应用会更注重 响应时间，而非吞吐量。Young generation 的垃圾回收通常会造成较长时间的全局暂停。
    而 old generation 的垃圾回收也有可能会造成长时间全局暂停，特别是使用大 堆内存 时。
    
    对于 Young generation, 其算法与 Parallel Collector 一致。
    
    对于 Old generation : 大多能够与应用代码平行执行。
    
    - initial mark 阶段： stop-the-world, 单线程执行，标记出应用代码可直接接触到的对象
      (Young generation 中可到达的对象)。
    - concurrent mark 阶段：与应用代码并行执行，单线程执行，递归标记出所有存活对象
     （根据对象树，遍历 Old generation 中的对象）。
      注意：此时应用在执行，initial mark 阶段的存活对象，有可能不再存活（floating garbage）；
      也有可能向 old generation 新申请对象入住。  
    - remark 阶段：stop-the-world, 并发执行。重新标记，防止新加入的存活对象。
      但不保证标记出所有可回收对象。
    - concurrent sweep 阶段：与应用代码并发执行，单线程执行，回收掉可回收的代码。
    
    但是注意，该回收器是唯一没有 compact 的垃圾回收器，也就是说，内存会越来越碎。越来越没有连续的大块儿内存。
    该垃圾回收器需要大的 堆内存。因为在 marking 阶段，仍然要保证有空间可被用于申请内存。
    因此，该垃圾回收器并不会等到 内存满了才去执行。如果真的内存满了，就会回退到使用 stop-the-world
    mark-sweep-compact 垃圾回收的方式。
    可以通过 `–XX:CMSInitiatingOccupancyFraction=n` 指定 old generation 占用百分比来触发GC，该值默认是 68.
    
    最后：为了应对内存碎片，该垃圾回收器会追踪常用对象尺寸，预估未来需求，必要时分割和合并空余内存块。

- Garbage-First (G1) collector
 
    JDK 1.7.4 之后支持。特性为：
    
    - 与 CMS collector 一样，可以与 应用代码平行运行
    - 可以 对齐空闲内存，但无需全局暂停
    - GC 频次会更多
    - 不必大量牺牲吞吐率
    - 不需要太大的 Java Heap
    
    相对于 CMS，G1的亮点是因为有了空闲内存 compacting, 所以不会有 内存碎片的问题。
    
    之前的垃圾回收器是将固定内存分为如下区域，每个 generation 都是连续的内存块。
    
    ![HEAP](http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/G1GettingStarted/images/HeapStructure.png)
    
    而 G1 则是分散的。
    ![G1 内存](http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/G1GettingStarted/images/slide9.png)
    
    G1 并不是实时的垃圾回收器。如果配置不合理，仍然有可能会触发 Full GC (stop-the-world, 单线程)

    RSets（Remembered Sets）：一个 region 对应一个 RSet，用来追踪该区域内对象的引用。 
    CSets（Collection Sets）：是一个要被 GC 的 region 的集合。 这些 region 类型不限（可能是 Eden, survivor, and/or old generation）。
    
    如果已经在用  CMS 或 ParallelOldGC 垃圾回收器时，有以下现象的话，适合切换至 G1 ：
    
    - Full GC 耗时太长，或太频繁
    - 新对象创建频率、数量变化很大。
    - 出现意料之外的长时间GC，或全局暂停（超过 0.5s 甚至1s以上） 
    
## 内存管理
是按照内存池进行管理。可能属于heap或non-heap。



## 垃圾回收是按照
* Yong generation
    * Eden
    * survivor x 2
* Old generation : (Tenured) 新生代中经过多轮垃圾回收仍在幸存区的数据会转移至此。
* Permanent generation: 存储JVM的元数据，比如类对象，方法对象（注意：是“对象”，区别与method area的code--字节码）

# 内存溢出 - OutOfMemoryError

- Java heap space : 一般是配置错误，通过 `–Xmx` 增加堆内存上限
- PermGen space ： 通过 `–XX:MaxPermSize=n` 增加内存
- Requested array size exceeds VM limit 

# JVM 参数

```text
-XX:+PrintFlagsFinal -XX:+PrintFlagsInitial -version  # 打印出相 -XX 参数


-Xmn256m        # 设置 young generation 的初始和最大大小。如果使用 G1 垃圾回收器，则不要设置。
-Xms256m        # 设置 heap 的初始大小
-Xmx2G          # 设置 heap 的最大大小
-Xnoclassgc     # 禁止针对 class 的 gc
-Xprof          # 
-Xrs            # 
-Xshare:mode    # 设置 class data sharing (CDS) 模式 : auto/on/off
-XshowSettings  #
-XshowSettings:category     # all/locale/properties/vm
-Xss1m          # 线程栈大小
-Xverify:mode   # remote/all/none

--add-reads module=target-module(,target-module)*
--add-exports module/package=target-module(,target-module)*
--add-opens module/package=target-module(,target-module)*
--illegal-access=parameter  # permit/warn/debug/deny
--limit-modules module[,module...]
--patch-module module=file(;file)*
--disable-@files


-XX:+CheckEndorsedAndExtDirs
-XX:-CompactStrings # 关闭字符串压缩。默认是开启压缩的，全部是 ASCII 的字符串会使用单字节内存存储。减少 50% 内存
-XX:CompilerDirectivesFile=file
-XX:CompilerDirectivesPrint
-XX:ConcGCThreads=n     # ParallelGCThreads 的线程数量
-XX:+DisableAttachMechanism     # 禁止工具（jcmd,jstack,jmap,jinfo）连接上来。默认是允许的。
-XX:+FailOverToOldVerifier


-XX:LargePageSizeInBytes=4m     # heap使用的 page 的size
-XX:MaxDirectMemorySize=size    # java.nio 可以使用的最大内存
-XX:-MaxFDLimit                 # 禁止设置可打开文件的 soft limit 为 hard limit。默认是允许的。
-XX:NativeMemoryTracking=mode   # off/summary/detail
-XX:ObjectAlignmentInBytes=alignment    # 
-XX:OnOutOfMemoryError=string 
-XX:+PerfDataSaveToFile
-XX:+PrintCommandLineFlags      #
-XX:+PreserveFramePointer
-XX:+PrintNMTStatistics
-XX:+RelaxAccessControlCheck
-XX:+ResourceManagement
-XX:ResourceManagementSampleInterval=value in milliseconds
-XX:SharedArchiveFile=path
-XX:SharedArchiveConfigFile=shared_config_file
-XX:SharedClassListFile=file_name
-XX:+ShowMessageBoxOnError
-XX:StartFlightRecording=parameter=value
-XX:ThreadStackSize=size

-XX:+DisableExplicitGC



–XX:+UseSerialGC
–XX:+UseParallelGC
–XX:+UseParallelOldGC
    -XX:MaxGCPauseMillis=200    # 指示垃圾回收器的全局暂停时间应当不超过该 毫秒数。
    –XX:ParallelGCThreads=n     # 垃圾回收器线程数，默认为 CPU 核心数量
    -XX:GCTimeRatio=99          # 垃圾回收所花费时长， 计算公式为 1/(1+n)。 默认的99表达为GC时间不超过 1% 的 CPU 时间。
–XX:+UseConcMarkSweepGC
    –XX:+CMSIncrementalMode                 # 默认： 'Disabled'。 
    –XX:+CMSIncrementalPacing               # 默认： 'Disabled'。 
    -XX:CMSIncrementalDutyCycle=n           #
    -XX:CMSIncrementalDutyCycleMin=n        #
    -XX:CMSIncrementalSafetyFactor=n        #
    -XX:CMSIncrementalOffset=n              #         
    -XX:CMSExpAvgFactor=n                   #  
    –XX:ParallelGCThreads=n                 # 
    –XX:CMSInitiatingOccupancyFraction=68   #
-XX:+UseG1GC
    -XX:G1HeapRegionSize=size       # 1M~32M
    -XX:InitiatingHeapOccupancyPercent=45

–XX:+PrintGCDetails     # 打印每次 GC 的详情
–XX:+PrintGCTimeStamps  # 打印每次 GC 的的时间戳
-server
-Xms512m
-Xmx1024m

-XX:PermSize=32m            # permanent generation 初始尺寸
–XX:MaxPermSize=n           # permanent generation 最大尺寸
–XX:MinHeapFreeRatio=40     # heap 中每个 generation 最小空余内存，如果空余内存小于该百分比，就自动扩大内存。
–XX:MaxHeapFreeRatio=70     # 如果空余内存多余该比例，则缩小内存。
–XX:NewSize=n               # young generation 初始大小
–XX:NewRatio=n              # 用于分割 heap。
                            # old generation 是 young generation 的多少倍。
                            # server 模式默认为8，client 模式默认为 2
–XX:SurvivorRatio=32        # 用于分割 young generation。按照默认值的话，Eden 和两个 Survivor 的比例为
                            # 32:1:1


-XX:ErrorFile=${CATALINA_HOME}/logs/hs_err_pid%p.log
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=${CATALINA_HOME}/logs/start.at.$today.dump.hprof 
-XX:+PrintGCDateStamps
-XX:+PrintGCDetails

-Dfile.encoding=UTF-8
-Djava.net.preferIPv4Stack=true

HAT
```
