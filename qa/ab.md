http://serverfault.com/questions/10852/what-limits-the-maximum-number-of-connections-on-a-linux-server

http://oldboy.blog.51cto.com/2561410/1336488

http://www.jb51.net/os/RedHat/61570.html

http://www.vpsee.com/2011/11/how-to-solve-ip_conntrack-table-full-dropping-packet-problem/

vi /var/log/messages

apache benchmark 是一个简单的压力测试工具。

```
sudo apt-get install apache2-utils
```

# 小文件

大小为891字节，小于1KB。并发为1000，结果如下：

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


并发为10000，结果如下：

```
zll@zll-pc:～$ ab -c 10000 -n 10000 http://m.nala.com.cn/resource/config.json
This is ApacheBench, Version 2.3 <$Revision: 1528965 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking m.nala.com.cn (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        nginx
Server Hostname:        m.nala.com.cn
Server Port:            80

Document Path:          /resource/config.json
Document Length:        891 bytes

Concurrency Level:      10000
Time taken for tests:   57.028 seconds
Complete requests:      10000
Failed requests:        34
   (Connect: 0, Receive: 0, Length: 34, Exceptions: 0)
Non-2xx responses:      35
Total transferred:      12420052 bytes
HTML transferred:       8894248 bytes
Requests per second:    175.35 [#/sec] (mean)
Time per request:       57027.570 [ms] (mean)
Time per request:       5.703 [ms] (mean, across all concurrent requests)
Transfer rate:          212.69 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  902 1532.2     11    6992
Processing:     3 1311 3781.8     31   57021
Waiting:        3 3973304821 74986938987.8     11 1419037131536
Total:          7 2213 4285.2    885   57021

Percentage of the requests served within a certain time (ms)
  50%    885
  66%   1617
  75%   2744
  80%   3685
  90%   7320
  95%   9176
  98%  10311
  99%  10939
 100%  57021 (longest request)
```



# apr_pollset_poll: The timeout specified has expired (70007)
ab 命令启用 `-k` 参数，使用keep-alive。

## server端修改

```
vi /etc/sysctl.conf
```

配置如下

```
net.ipv4.netfilter.ip_conntrack_max = 3276800
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_orphan_retries = 1
net.ipv4.tcp_fin_timeout = 25
net.ipv4.tcp_max_orphans = 8192
net.ipv4.ip_local_port_range = 32768    61000
```
使立即生效

```
sysctl -p /etc/sysctl.conf
```


# POST 提交

```bash
# 先通过 CURL 等方式确认测试对象
curl \
    -v \
    -X POST \
    -d username=aaa \
    -d password=bbb \
    https://kingsilk.net/oauth2/rs/api/s/login/pwd
#    --trace-ascii /dev/stdout \
 
cat > postFile <<EOF
username=aaa&password=bbb
EOF

vi postFile
:set binary noeol    # 去掉行尾换行符
:wq

# 先只执行一个请求，已验证是否是 http 200 的结果
ab \
    -v 4 \
    -T application/x-www-form-urlencoded \
    -p postFile \
    -c 1 \
    -n 1 \
    https://kingsilk.net/oauth2/rs/api/s/login/pwd

# 确认OK后，增加并发数，进行压力测试
ab \
    -p postFile \
    -T application/x-www-form-urlencoded \
    -c 100 \
    -n 2000 \
    https://kingsilk.net/oauth2/rs/api/s/login/pwd
```
