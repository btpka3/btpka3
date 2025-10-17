https://docs.haproxy.org/3.2/intro.html

http://serverfault.com/questions/401040/maximizing-tcp-connections-on-haproxy-load-balancer

http://my.oschina.net/hncscwc/blog/199152?from=20140223


|config|description|
|---|---|
|haproxy -n 2000 | 设置总共的最大连接数|
|haproxy -N 2000 | 设置per-proxy默认的最大连接数（>=client与haproxy、haproxy与所有后台server的连接数之和）|
|haproxy.cfg/global/maxconn | 同命令行 -n 参数 |
|haproxy.cfg/default/maxconn | 同命令行 -N 参数 |
|haproxy.cfg/listen/maxconn | 针对当前代理：client与haproxy之间的最大连接数 |
|haproxy.cfg/backend/server/maxconn | 针对当前代理：haproxy与后台server之间的最大连接数 |


maxsock = 10(默认值) + global.maxconn * 2 + global.maxpipes * 2 + bind数量 + check数量

```
# 查看pid
ps aux | grep haproxy

# 查看该进程的限制
cat /proc/${pid}/limits
[root@ha208 ~]# cat /proc/26387/limits
Limit                     Soft Limit           Hard Limit           Units
Max cpu time              unlimited            unlimited            seconds
Max file size             unlimited            unlimited            bytes
Max data size             unlimited            unlimited            bytes
Max stack size            10485760             unlimited            bytes
Max core file size        0                    unlimited            bytes
Max resident set          unlimited            unlimited            bytes
Max processes             61621                61621                processes
Max open files            131096               131096               files
Max locked memory         32768                32768                bytes
Max address space         unlimited            unlimited            bytes
Max file locks            unlimited            unlimited            locks
Max pending signals       61621                61621                signals
Max msgqueue size         819200               819200               bytes
Max nice priority         0                    0
Max realtime priority     0                    0
```

