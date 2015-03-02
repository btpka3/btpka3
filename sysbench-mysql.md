
参考阿里云关系数据库RDS服务的[MySQL性能测试报告](http://help.aliyun.com/view/11108238_13440406.html)

MyISAM真得比InnoDB快么？一个参考 《MySQL管理之道：性能调优、高可用与监控》第一章的 图1-2 和 图1-3.

# sysbench 压力测试命令

需要使用下述命令，并依次替换最后一个参数为 `prepare`, `run`, `cleanup` 进行测试。

```
sysbench                         \
    --test=oltp                  \
    --num-threads=16             \
    --oltp-table-size=1000000    \
    --db-driver=mysql            \
    --mysql-host=192.168.101.86  \
    --mysql-port=3306            \
    --mysql-user=test            \
    --mysql-password=nalanala    \
    --mysql-db=test              \
    --mysql-table-engine=myisam  \
    run
```



# test.86

|item|info|
|----|----|
|CPU    | AMD Athlon(tm) II X2 245 Processor * 2|
|Memory | 4G |
|MySQL  | mysqld  Ver 5.5.37-0ubuntu0.12.04.1-log for debian-linux-gnu on x86_64 ((Ubuntu)) |


## myisam

```
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16

Doing OLTP test.
Running mixed OLTP test
Using Special distribution (12 iterations,  1 pct of values are returned in 75 pct cases)
Using "LOCK TABLES WRITE" for starting transactions
Using auto_inc on the id column
Maximum number of requests for OLTP test is limited to 10000
Threads started!
Done.

OLTP test statistics:
    queries performed:
        read:                            140000
        write:                           50000
        other:                           20000
        total:                           210000
    transactions:                        10000  (75.81 per sec.)
    deadlocks:                           0      (0.00 per sec.)
    read/write requests:                 190000 (1440.39 per sec.)
    other operations:                    20000  (151.62 per sec.)

Test execution summary:
    total time:                          131.9083s
    total number of events:              10000
    total time taken by event execution: 2108.6102
    per-request statistics:
         min:                                 12.67ms
         avg:                                210.86ms
         max:                               1704.51ms
         approx.  95 percentile:             239.32ms

Threads fairness:
    events (avg/stddev):           625.0000/0.00
    execution time (avg/stddev):   131.7881/0.07
```

## innodb

```
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16

Doing OLTP test.
Running mixed OLTP test
Using Special distribution (12 iterations,  1 pct of values are returned in 75 pct cases)
Using "BEGIN" for starting transactions
Using auto_inc on the id column
Maximum number of requests for OLTP test is limited to 10000
Threads started!
Done.

OLTP test statistics:
    queries performed:
        read:                            140126
        write:                           50045
        other:                           20018
        total:                           210189
    transactions:                        10009  (136.43 per sec.)
    deadlocks:                           0      (0.00 per sec.)
    read/write requests:                 190171 (2592.18 per sec.)
    other operations:                    20018  (272.86 per sec.)

Test execution summary:
    total time:                          73.3634s
    total number of events:              10009
    total time taken by event execution: 1172.8372
    per-request statistics:
         min:                                 70.17ms
         avg:                                117.18ms
         max:                               7278.49ms
         approx.  95 percentile:             239.60ms

Threads fairness:
    events (avg/stddev):           625.5625/9.97
    execution time (avg/stddev):   73.3023/0.04
```



# prod.80

|item|info|
|----|----|
|CPU    | Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz * 24|
|Memory | 32G |
|MySQL  | mysql  Ver 14.14 Distrib 5.6.20, for Linux (x86_64) using  EditLine wrapper |


## myisam

```
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16

Doing OLTP test.
Running mixed OLTP test
Using Special distribution (12 iterations,  1 pct of values are returned in 75 pct cases)
Using "LOCK TABLES WRITE" for starting transactions
Using auto_inc on the id column
Maximum number of requests for OLTP test is limited to 10000
Threads started!
Done.

OLTP test statistics:
    queries performed:
        read:                            140000
        write:                           50000
        other:                           20000
        total:                           210000
    transactions:                        10000  (108.07 per sec.)
    deadlocks:                           0      (0.00 per sec.)
    read/write requests:                 190000 (2053.30 per sec.)
    other operations:                    20000  (216.14 per sec.)

Test execution summary:
    total time:                          92.5338s
    total number of events:              10000
    total time taken by event execution: 1479.4782
    per-request statistics:
         min:                                  9.04ms
         avg:                                147.95ms
         max:                                361.57ms
         approx.  95 percentile:             172.90ms

Threads fairness:
    events (avg/stddev):           625.0000/0.00
    execution time (avg/stddev):   92.4674/0.04
```

## innodb

```
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16

Doing OLTP test.
Running mixed OLTP test
Using Special distribution (12 iterations,  1 pct of values are returned in 75 pct cases)
Using "BEGIN" for starting transactions
Using auto_inc on the id column
Maximum number of requests for OLTP test is limited to 10000
Threads started!
Done.

OLTP test statistics:
    queries performed:
        read:                            140014
        write:                           50005
        other:                           20002
        total:                           210021
    transactions:                        10001  (518.27 per sec.)
    deadlocks:                           0      (0.00 per sec.)
    read/write requests:                 190019 (9847.07 per sec.)
    other operations:                    20002  (1036.53 per sec.)

Test execution summary:
    total time:                          19.2970s
    total number of events:              10001
    total time taken by event execution: 308.5343
    per-request statistics:
         min:                                 15.79ms
         avg:                                 30.85ms
         max:                                231.48ms
         approx.  95 percentile:              43.58ms

Threads fairness:
    events (avg/stddev):           625.0625/4.29
    execution time (avg/stddev):   19.2834/0.01
```