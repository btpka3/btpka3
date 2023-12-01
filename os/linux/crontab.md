


```bash
# 编辑当前用户的 定时任务
crontab -e

ls -l /etc/cron.d/              # 自定义cron 表达式执行的任务
ls -l /etc/crontab              # 系统级别的定时任务
ls -l /etc/cron.daily/          #
ls -l /etc/cron.hourly/
ls -l /etc/cron.monthly/
ls -l /etc/cron.weekly/

sudo ls -l /var/spool/cron/                      # `crontab -e` 命令保存文件
sudo ls -l /var/spool/cron/$USER_NAME
sudo ls -l /var/spool/cron/crontabs/$USER_NAME
```
