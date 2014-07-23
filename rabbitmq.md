## RabbitMQ常用命令

```sh
# 启停命令等
[me@localhost:~] sudo service rabbitmq-server xxx

# 重置（即清除所有queue，binding，message等）
[me@localhost:~] sudo rabbitmqctl stop_app
[me@localhost:~] sudo rabbitmqctl force_reset
[me@localhost:~] sudo rabbitmqctl start_app
```