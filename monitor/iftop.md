

Linux 下监控网络流量的工具、命令
1. iftop

    参考[这里](http://blog.csdn.net/gaojinshan/article/details/40781241)

    ```bash
    yum install iftop
    iftop -i eth1
    ```
1. iptraf-ng   实时局域网IP监控

    ```bash
    # 缺点，看不到PID
    yum install iptraf-ng  
    ```

1. nethogs

    ```bash
    yum install nethogs
    nethogs
    ```
1. tcptrack

1. nload
1. iostat   输入/输出统计
1. ifstat
1. watch ifconfig
1. watch cat /proc/net/dev
1. bwm-ng
1. Monitorix

1. `ss -l -p -n` 

    ss from the iproute2 package (which is similar to netstat)
