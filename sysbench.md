

# CPU
根据下面的测试数据，I3-3240（4核） 和 Xeon E31230（8核）在单线程执行测试的结果相仿，时间分别为 24.9281s和 26.5128s，但是分别给设置合适的线程数后，时间为 8.0047s 和 4.1689s。

## I3-3240 （4）

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

4线程执行压力测试： `sysbench --test=cpu --cpu-max-prime=20000 --num-threads=4 run`

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

16线程执行压力测试： `sysbench --test=cpu --cpu-max-prime=20000 --num-threads=16 run`

```txt
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16

Doing CPU performance benchmark

Threads started!
Done.

Maximum prime number checked in CPU test: 20000


Test execution summary:
    total time:                          7.9028s
    total number of events:              10000
    total time taken by event execution: 126.0871
    per-request statistics:
         min:                                  2.67ms
         avg:                                 12.61ms
         max:                                 59.78ms
         approx.  95 percentile:              29.83ms

Threads fairness:
    events (avg/stddev):           625.0000/59.00
    execution time (avg/stddev):   7.8804/0.01
```

## Xeon E31230

查看CPU 信息 ：`cat /proc/cpuinfo|grep "model name"`

```txt
model name	: Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
model name	: Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
model name	: Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
model name	: Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
model name	: Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
model name	: Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
model name	: Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
model name	: Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
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
    total time:                          26.5138s
    total number of events:              10000
    total time taken by event execution: 26.5128
    per-request statistics:
         min:                                  2.64ms
         avg:                                  2.65ms
         max:                                  3.16ms
         approx.  95 percentile:               2.65ms

Threads fairness:
    events (avg/stddev):           10000.0000/0.00
    execution time (avg/stddev):   26.5128/0.00
```

8线程执行压力测试： `sysbench --test=cpu --cpu-max-prime=20000 --num-threads=8 run`

```txt
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 8

Doing CPU performance benchmark

Threads started!
Done.

Maximum prime number checked in CPU test: 20000


Test execution summary:
    total time:                          4.1703s
    total number of events:              10000
    total time taken by event execution: 33.3513
    per-request statistics:
         min:                                  2.67ms
         avg:                                  3.34ms
         max:                                 18.35ms
         approx.  95 percentile:               3.48ms

Threads fairness:
    events (avg/stddev):           1250.0000/157.26
    execution time (avg/stddev):   4.1689/0.00
```

16线程执行压力测试： `sysbench --test=cpu --cpu-max-prime=20000 --num-threads=16 run`

```txt
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16

Doing CPU performance benchmark

Threads started!
Done.

Maximum prime number checked in CPU test: 20000


Test execution summary:
    total time:                          3.8671s
    total number of events:              10000
    total time taken by event execution: 61.7081
    per-request statistics:
         min:                                  3.06ms
         avg:                                  6.17ms
         max:                                 38.10ms
         approx.  95 percentile:              14.09ms

Threads fairness:
    events (avg/stddev):           625.0000/24.28
    execution time (avg/stddev):   3.8568/0.01
```