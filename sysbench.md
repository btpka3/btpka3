

# CPU
## I3

查看CPU 信息 ：`cat /proc/cpuinfo|grep "model name"`

```txt
model name	: Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz
model name	: Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz
model name	: Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz
model name	: Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz
```

单线程进行压力测试 ： `sysbench --test=cpu --cpu-max-prime=20000 run`
```txt
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 1

Doing CPU performance benchmark

Threads started!
Done.

Maximum prime number checked in CPU test: 20000


Test execution summary:
    total time:                          24.9302s
    total number of events:              10000
    total time taken by event execution: 24.9281
    per-request statistics:
         min:                                  2.47ms
         avg:                                  2.49ms
         max:                                  5.70ms
         approx.  95 percentile:               2.52ms

Threads fairness:
    events (avg/stddev):           10000.0000/0.00
    execution time (avg/stddev):   24.9281/0.00
```

多线程执行压力测试： `sysbench --test=cpu --cpu-max-prime=20000 --num-threads=4 run`

```txt
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 4

Doing CPU performance benchmark

Threads started!
Done.

Maximum prime number checked in CPU test: 20000


Test execution summary:
    total time:                          8.0153s
    total number of events:              10000
    total time taken by event execution: 32.0187
    per-request statistics:
         min:                                  2.51ms
         avg:                                  3.20ms
         max:                                 20.27ms
         approx.  95 percentile:               4.76ms

Threads fairness:
    events (avg/stddev):           2500.0000/77.21
    execution time (avg/stddev):   8.0047/0.01
```
