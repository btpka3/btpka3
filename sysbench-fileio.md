

```
# 先确定cpu是几核的，然后在设置后续的测试使用的线程数为该数值的2倍， 但是这里测试的是单块硬盘，应当以单线程进行测试。
cat /proc/cpuinfo | grep "model name" | wc -l



lsscsi -c   # 查看硬盘信息
fdisk -l    # 查看分区信息
df -h       # 参看分区使用状况


# 在当前目录创建所需的测试文件
sysbench --test=fileio --num-threads=8 --file-total-size=3G --file-test-mode=rndrw prepare

# 运行测试
sysbench --test=fileio --num-threads=8 --file-total-size=3G --file-test-mode=rndrw run

# 清理
sysbench --test=fileio --num-threads=8 --file-total-size=3G --file-test-mode=rndrw cleanup
```

|target    |rndrd.transfer|rndrd.iops        |rndwr.transfer|rndwr.iops       |rndrw.transfer|rndrw.iops       |
|----------|--------------|------------------|--------------|-----------------|--------------|-----------------|
|zll's pc  |3.8934Mb/sec  |   249.18 req/sec |1.0622Mb/sec  |   67.98 req/sec |1.7472Mb/sec  |  111.82 req/sec |
|sever ssd |4.6985Gb/sec  |307921.13 req/sec |244.37Mb/sec  |15639.80 req/sec |540.66Mb/sec  |34602.23 req/sec |
|server    |3.5748Gb/sec  |234278.68 req/sec |12.246Mb/sec  |  783.75 req/sec |23.766Mb/sec  | 1521.04 req/sec |






# zll普通台式机硬盘

cpu: Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz * 4

硬盘 ： ATA WDC WD10EZEX-08M 1TB 7200 RPM 

```
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 8

Extra file open flags: 0
128 files, 24Mb each
3Gb total file size
Block size 16Kb
Number of random requests for random IO: 10000
Read/Write ratio for combined random IO test: 1.50
Periodic FSYNC enabled, calling fsync() each 100 requests.
Calling fsync() at the end of test, Enabled.
Using synchronous I/O mode
Doing random r/w test
Threads started!
Done.

Operations performed:  6009 Read, 4002 Write, 12800 Other = 22811 Total
Read 93.891Mb  Written 62.531Mb  Total transferred 156.42Mb  (1.7472Mb/sec)
  111.82 Requests/sec executed

Test execution summary:
    total time:                          89.5257s
    total number of events:              10011
    total time taken by event execution: 200.3244
    per-request statistics:
         min:                                  0.00ms
         avg:                                 20.01ms
         max:                                441.67ms
         approx.  95 percentile:              96.36ms

Threads fairness:
    events (avg/stddev):           1251.3750/49.66
    execution time (avg/stddev):   25.0405/0.95
```

# 服务器90硬盘 SSD？

CPU： Intel(R) Xeon(R) CPU E3-1230 V2 @ 3.30GHz * 8

硬盘: ATA Samsung SSD 840

```
sysbench 0.4.12:  multi-threaded system evaluation benchmark

128 files, 24576Kb each, 3072Mb total
Creating files for the test...
[root@prod90 1]# sysbench --test=fileio --num-threads=16 --file-total-size=3G --file-test-mode=rndrw run
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16

Extra file open flags: 0
128 files, 24Mb each
3Gb total file size
Block size 16Kb
Number of random requests for random IO: 10000
Read/Write ratio for combined random IO test: 1.50
Periodic FSYNC enabled, calling fsync() each 100 requests.
Calling fsync() at the end of test, Enabled.
Using synchronous I/O mode
Doing random r/w test
Threads started!
Done.

Operations performed:  6004 Read, 4003 Write, 12803 Other = 22810 Total
Read 93.812Mb  Written 62.547Mb  Total transferred 156.36Mb  (540.66Mb/sec)
34602.23 Requests/sec executed

Test execution summary:
    total time:                          0.2892s
    total number of events:              10007
    total time taken by event execution: 0.3881
    per-request statistics:
         min:                                  0.00ms
         avg:                                  0.04ms
         max:                                 24.90ms
         approx.  95 percentile:               0.04ms

Threads fairness:
    events (avg/stddev):           625.4375/165.06
    execution time (avg/stddev):   0.0243/0.01
```


#  服务器80硬盘

CPU : Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz * 24

硬盘: SEAGATE ST3300657SS  15000转/分

```
[root@lizi80 1]# cat /proc/cpuinfo | grep "model name" | wc -l
24
[root@lizi80 1]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             625G   26G  568G   5% /
tmpfs                  16G     0   16G   0% /dev/shm
/dev/sda1             2.0G   75M  1.8G   4% /boot
/dev/sda5              97G   18G   74G  19% /data0
/dev/sda6              53G  180M   51G   1% /data1
/dev/sda3             193G   27G  156G  15% /home
/dev/sda7              29G  172M   28G   1% /opt
/dev/sda11            9.7G  169M  9.0G   2% /tmp
/dev/sda8              29G  1.3G   27G   5% /usr
/dev/sda9              29G  516M   27G   2% /usr/local
/dev/sda10             29G  320M   28G   2% /var
192.168.71.20:/data0/web-app/b2c/user_upload
                      533G  350G  156G  70% /home/www/user_upload
[root@lizi80 1]# pwd
/data0/tmp/1
```

/data0/tmp/1 测试结果

```
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 48

Extra file open flags: 0
128 files, 24Mb each
3Gb total file size
Block size 16Kb
Number of random requests for random IO: 10000
Read/Write ratio for combined random IO test: 1.50
Periodic FSYNC enabled, calling fsync() each 100 requests.
Calling fsync() at the end of test, Enabled.
Using synchronous I/O mode
Doing random r/w test
Threads started!
Done.

Operations performed:  6044 Read, 4032 Write, 12765 Other = 22841 Total
Read 94.438Mb  Written 63Mb  Total transferred 157.44Mb  (23.766Mb/sec)
 1521.04 Requests/sec executed

Test execution summary:
    total time:                          6.6244s
    total number of events:              10076
    total time taken by event execution: 20.8872
    per-request statistics:
         min:                                  0.00ms
         avg:                                  2.07ms
         max:                                186.28ms
         approx.  95 percentile:               9.78ms

Threads fairness:
    events (avg/stddev):           209.9167/33.04
    execution time (avg/stddev):   0.4352/0.11
```