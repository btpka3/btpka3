apache benchmark 是一个简单的压力测试工具。

# 小文件

```
zll@zll-pc:~$ ab -c 1000 -n 1000 http://m.nala.com.cn/resource/config.json
This is ApacheBench, Version 2.3 <$Revision: 1528965 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking m.nala.com.cn (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx
Server Hostname:        m.nala.com.cn
Server Port:            80

Document Path:          /resource/config.json
Document Length:        891 bytes

Concurrency Level:      1000                      # 并发数
Time taken for tests:   0.983 seconds             # 整个测试持续的时间
Complete requests:      1000                      # 完成的请求数量
Failed requests:        0                         # 失败的请求数量
Total transferred:      1244000 bytes             # 总共传输了多少字节
HTML transferred:       891000 bytes              # HTML内容所占的字节
Requests per second:    1016.99 [#/sec] (mean)    # “每秒事务数”（是平均值）
Time per request:       983.297 [ms] (mean)       # “平均事务响应时间”
Time per request:       0.983 [ms] (mean, across all concurrent requests)   # 每个请求实际运行时间的平均值
Transfer rate:          1235.48 [Kbytes/sec] received  # 传输速率

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        3   25  18.9     18      66
Processing:     4  147 273.8     19     887
Waiting:        4  109 223.8     19     870
Total:          7  171 283.9     36     927

Percentage of the requests served within a certain time (ms)
  50%     36                         # 50%的请求的响应时间小于36ms
  66%     82
  75%     96
  80%    331
  90%    897
  95%    912
  98%    920
  99%    923
 100%    927 (longest request)       # 完成所有请求，需要927ms
```