http://cbonte.github.io/haproxy-dconv/configuration-1.5.html

http://serverfault.com/questions/401040/maximizing-tcp-connections-on-haproxy-load-balancer

http://my.oschina.net/hncscwc/blog/199152?from=20140223


|||
|---|---|
|haproxy -n 2000 | 设置总共的最大连接数|
|haproxy -N 2000 | 设置per-proxy默认的最大连接数（>=client与haproxy、haproxy与所有后台server的连接数之和）|
|haproxy.cfg/global/maxconn | 同命令行 -n 参数 |
|haproxy.cfg/default/maxconn | 同命令行 -N 参数 |
|haproxy.cfg/listen/maxconn | 针对当前代理：client与haproxy之间的最大连接数 |
|haproxy.cfg/backend/server/maxconn | 针对当前代理：haproxy与后台server之间的最大连接数 |


