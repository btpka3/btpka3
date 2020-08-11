

linux 监控命令


```txt
f       - 添加、删除、排序 列
  s     - 设置要排序的字段
  q     - 退出
  
```
# CPU

* dstat
* top
* vmstat
* mpstat -P ALL 1


# cpu 利用率 utilization


# ref
- [How do I Find Out Linux CPU Utilization?](https://www.cyberciti.biz/tips/how-do-i-find-out-linux-cpu-utilization.html)

```bash
yum install sysstat
mpstat -P ALL
sar -u 2 5
uptime
```
