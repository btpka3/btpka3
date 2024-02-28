


```bash
# 确保 crond 服务运行ing
systemctl status crond.service
systemctl status systemd-journald.service
less /usr/lib/systemd/system/crond.service
sudo journalctl -u crond
sudo journalctl -b -e   # 查找关键词 CRON， 仍然启动失败就重启 crond 服务

# 检查当前用于已有的任务。如果使用sudo ，则会查看root 用户的任务
crontab -l
# 编辑当前用户的 定时任务
crontab -e
man 5 crontab  # 查看 crontab 文件格式， 表达式格式最小粒度到分钟

# 相关配置文件
ls -l /etc/cron.d/              # 自定义cron 表达式执行的任务，必须 root有可执行权限。
ls -l /etc/crontab              # 系统级别的定时任务
ls -l /etc/cron.daily/          # 必须 root有可执行权限。
ls -l /etc/cron.hourly/         # 必须 root有可执行权限。
ls -l /etc/cron.monthly/        # 必须 root有可执行权限。
ls -l /etc/cron.weekly/         # 必须 root有可执行权限。

sudo ls -l /var/spool/cron/                      # `crontab -e` 命令保存文件
sudo ls -l /var/spool/cron/$USER_NAME
sudo ls -l /var/spool/cron/crontabs/$USER_NAME


# cron 相关日志, 具体参考 syslog-ng 的相关配置
sudo less -l /var/log/syslog  # Ubuntu, Debian
sudo less -l /var/log/cron    # RedHat, CentOS
```


# cron 表达式

```bash
# 有6、7个参数
# 秒 分钟 小时 日 月 星期几 年
0 * * * * ?  # 每分钟

特殊符号：
*（通配符）：匹配任意值
,（列表）: 连接多个值 : `6,12,18`
-（范围）：用于指定一个范围内的取值， `9-17`
/（步长）：用于指定一个取值的步长 : `*/30`
?（无意义占位符）：用于指定一个字段没有具体的取值
#（日历偏移量）：用于指定某个月份的第几个周几，例如0 0 0 ? * 3#1表示每个月的第一个星期三执行任务。
L（Last）：表示某个指定时间内的最后一天，比如0 0 L * * ?表示每月的最后一天执行任务。
W（Weekday）：表示距离指定日期最近的工作日，比如0 0 0 15W * ?表示当月第15个工作日执行任务。如果15号是工作日，则执行任务；如果15号是周末，则任务会提前到最近的工作日即14号执行。
C（Calendar）：表示距离指定日期最近的那个日子

```

# crontab 文件示例

```plain
ENV_VAR1=xxx
0 * * * *   /path/to/xxx.sh
```



