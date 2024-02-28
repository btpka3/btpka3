
# jstat

[jstat](http://docs.oracle.com/javase/8/docs/technotes/tools/unix/jstat.html)
可以用来监视VM内存内的各种堆和非堆的大小及其内存使用量

## 使用方法

```bash
# 查看 man 手册
man jstat

jstat -gcutil 232683 1s

jstat -help
Usage: jstat -help|-options
       jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]



# 查看可用选项
jstat -options
-class
-compiler
-gc
-gccapacity
-gccause
-gcmetacapacity
-gcnew
-gcnewcapacity
-gcold
-gcoldcapacity
-gcutil
-printcompilation
```


```bash
jstat -class 22423
Loaded Bytes  Unloaded    Bytes       Time
 12621 22686.5      121   180.3       9.51

:<<EOF
Loaded      - 已加载 class 的数量
Bytes       - 已加载的字节数（单位：kB）
Unloaded    - 已卸载 class 的数量
Bytes       - 已卸载的字节数（单位：kB）
Time        - 类加载/卸载总耗时
EOF
```

## -gcutil

```bash
jstat -gcutil 17402 1000 5
  S0     S1     E      O      M     CCS    YGC     YGCT    FGC    FGCT     GCT
  0.00  98.18  78.51  50.33  97.89  95.73     31    0.477     3    0.445    0.922
  0.00  98.18  78.51  50.33  97.89  95.73     31    0.477     3    0.445    0.922
  0.00  98.18  78.51  50.33  97.89  95.73     31    0.477     3    0.445    0.922
  0.00  98.18  78.51  50.33  97.89  95.73     31    0.477     3    0.445    0.922
  0.00  98.18  78.51  50.33  97.89  95.73     31    0.477     3    0.445    0.922


:<<EOF
S0      — Survivor space 0 区已使用空间的百分比
S1      — Survivor space 1 区已使用空间的百分比
E       — Eden space 区已使用空间的百分比
O       — Old space 区已使用空间的百分比
P       — Perm space 区已使用空间的百分比
M       — Meta space 区已使用空间的百分比
CCS     -
YGC     — Young GC 次数
YGCT    – Young GC 耗时(单位：秒)
FGC     — Full GC 次数
FGCT    – Full GC 耗时(单位：秒)
GCT     — GC 总耗时(单位：秒)
EOF
```


## -gccapacity

```bash
jstat -gccapacity 22423 1000 5
NGCMN   NGCMX     NGC     S0C    S1C     EC         OGCMN     OGCMX      OGC        OC           MCMN MCMX       MC         CCSMN CCSMX       CCSC      YGC    FGC
43648.0 174720.0  43648.0 4352.0 4352.0  34944.0    87424.0   349568.0   110284.0   110284.0      0.0 1107968.0  66764.0      0.0 1048576.0   8652.0    220    28
43648.0 174720.0  43648.0 4352.0 4352.0  34944.0    87424.0   349568.0   110284.0   110284.0      0.0 1107968.0  66764.0      0.0 1048576.0   8652.0    220    28
43648.0 174720.0  43648.0 4352.0 4352.0  34944.0    87424.0   349568.0   110284.0   110284.0      0.0 1107968.0  66764.0      0.0 1048576.0   8652.0    220    28
43648.0 174720.0  43648.0 4352.0 4352.0  34944.0    87424.0   349568.0   110284.0   110284.0      0.0 1107968.0  66764.0      0.0 1048576.0   8652.0    220    28
43648.0 174720.0  43648.0 4352.0 4352.0  34944.0    87424.0   349568.0   110284.0   110284.0      0.0 1107968.0  66764.0      0.0 1048576.0   8652.0    220    28
:<<EOF
NGCMN   - new generation 最小容量（单位:kB)
NGCMX   - new generation 最大容量（单位:kB)
NGC     - new generation 当前容量（单位:kB)
S0C     - Survivor space 0 当前容量（单位:kB)
S1C     - Survivor space 1 当前容量（单位:kB)
EC      - eden space 当前容量（单位:kB)
OGCMN   - old generation 最小容量（单位:kB)
OGCMX   - old generation 最大容量（单位:kB)
OGC     - old generation 当前容量（单位:kB)
OC      - old space 已用量（单位:kB)
MCMN    - metaspace 最小容量（单位:kB)
MCMX    - metaspace 最大容量（单位:kB)
MC      - metaspace 当前容量（单位:kB)
CCSMN   - 压缩的 class space 最小容量（单位:kB)
CCSMX   - 压缩的 class space 最大容量（单位:kB)
CCSC    - 压缩的 class space 当前容量（单位:kB)
YGC     - Young GC 次数
FGC     — Full GC 次数
EOF
```


## -gc
垃圾回收堆的统计

```bash
jstat -gc 17402 1000 5
 S0C    S1C     S0U      S1U   EC       EU        OC         OU        MC      MU      CCSC   CCSU       YGC   YGCT    FGC    FGCT     GCT
14848.0 20992.0 14818.5  0.0   365568.0 161780.7  124928.0   62881.5   67840.0 66434.5 8704.0 8332.8     32    0.489   3      0.445    0.934
14848.0 20992.0 14818.5  0.0   365568.0 161780.7  124928.0   62881.5   67840.0 66434.5 8704.0 8332.8     32    0.489   3      0.445    0.934
14848.0 20992.0 14818.5  0.0   365568.0 162229.1  124928.0   62881.5   67840.0 66434.5 8704.0 8332.8     32    0.489   3      0.445    0.934
14848.0 20992.0 14818.5  0.0   365568.0 162229.1  124928.0   62881.5   67840.0 66434.5 8704.0 8332.8     32    0.489   3      0.445    0.934
14848.0 20992.0 14818.5  0.0   365568.0 162229.1  124928.0   62881.5   67840.0 66434.5 8704.0 8332.8     32    0.489   3      0.445    0.934

:<<EOF
S0C     - Survivor space 0 当前容量（单位:kB)  : 14.5M
S1C     - Survivor space 1 当前容量（单位:kB)  : 20.5M
S0U     - Survivor space 0 已用量（单位:kB)    : 14.5M
S1U     - Survivor space 1 已用量（单位:kB)    : 0M
EC      - Eden space 当前容量（单位:kB)        : 257M
EU      - Eden space 已用容量（单位:kB)        : 158M
OC      - old space 当前容量（单位:kB)         : 122M
OU      - old space 已用量（单位:kB)           : 61M
MC      - Metaspace 当前容量（单位:kB)         : 66M
MU      - Metaspace 已用量（单位:kB)           : 65M
CCSC    - 压缩的 class space 当前容量（单位:kB) : 8.5M
CCSU    - 压缩的 class space 已用量（单位:kB)   : 8.1M
YGC     - Young GC 次数                       : 32
YGCT    - Young GC 耗时(单位：秒)              : 0.489秒
FGC     — Full GC 次数                        : 3
FGCT    – Full GC 耗时(单位：秒)               : 0.445秒
CGC     - Concurrent GC Count
CGCT    - Concurrent GC Collection Time

GCT     — GC 总耗时(单位：秒)                  : 0.934秒
EOF
```

### -compiler
HotSpot Just-In-Time 编译器统计
```bash
jstat -compiler 22423
Compiled Failed Invalid   Time   FailedType FailedMethod
   11419      3       0    84.81          1 groovy/lang/MetaClassImpl$1MOPIter methodNameAction
:<<EOF
Compiled           # 进行编译任务的数量
Failed             # 失败的编译任务数量
Invalid            # 无效的编译任务的数量
Time               # 编译消耗的时间
FailedType         # 最后一次编译失败的类型
FailedMethod       # 最后一次编译失败的类和方法
EOF
```


