## rabbitmq
## mqtt

[MQTT](http://mqtt.org/) 是一个面向机器的消息通讯协议。


## web socket 

## AMQP

###  exchange

|exchange type  |Default pre-declared names     |memo               |
|---------------|-------------------------------|-----------------|
|Direct         | "" (default), `amq.direct`    |使用 routing key |
|Fanout         | `amq.fanout`                  |不用 routing key? |
|Topic          | `amq.topic`                   |使用 routing key |
|Headers        | `amq.match`, `amq.headers`    |不用 routing key |

除了类型，其他属性：

* name 
* Durability    : RabbitMQ 服务重启后是否该 Exchange 是否还存在。
* Auto-delete   : 所有 queue 都使用完毕后，是否自动删除该 exchange
* Arguments     : 对实现厂商有意义

### Queue
Queue 用来存储消息。
Queue 在使用之前，必须先声明。
名称以 `amq.` 开头的 Queue 是 内部保留使用的。

有以下属性：
* Name
* Durable       : RabbitMQ 服务重启后 该 Queue 是否还存在
* Exclusive     : 限定只能有一个连接使用该queue，且失去连接时，自动删除该 queue。
* Auto-delete   : 当最后一个 consumer 取消订阅该 queue 后，是否删除该 queue。
* Arguments     : 对实现厂商有意义，比如 TTL。


## 参考

* [AMQP 0-9-1 Model Explained](https://www.rabbitmq.com/tutorials/amqp-concepts.html) 
