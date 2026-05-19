
# plantuml 示例



## 时序图 (Sequence Diagram)
```plantuml
@startuml
title 用户登录流程
actor User as U
participant "前端界面" as FE
participant "后端服务" as BE
database "数据库" as DB

U -> FE : 输入用户名密码
FE -> BE : 发送登录请求
BE -> DB : 查询用户信息
DB --> BE : 返回用户数据
alt 验证成功
    BE --> FE : 返回 Token
    FE --> U : 跳转首页
else 验证失败
    BE --> FE : 返回错误信息
    FE --> U : 提示错误
end
@enduml

```

## 类图 (Class Diagram)
```plantuml
@startuml
class Animal {
    +String name
    +int age
    +makeSound()
}

class Dog {
    +bark()
}

class Cat {
    +meow()
}

Animal <|-- Dog : 继承
Animal <|-- Cat : 继承

interface Pet {
    +play()
}

Dog ..|> Pet : 实现
Cat ..|> Pet : 实现

note right of Dog
  狗是人类的忠实朋友
end note
@enduml

```

## 用例图 (Use Case Diagram)
```plantuml
@startuml
left to right direction
actor "顾客" as Customer
actor "管理员" as Admin

rectangle "在线书店系统" {
    usecase "浏览书籍" as UC1
    usecase "搜索书籍" as UC2
    usecase "下单购买" as UC3
    usecase "管理库存" as UC4
    usecase "查看报表" as UC5
}

Customer --> UC1
Customer --> UC2
Customer --> UC3

Admin --> UC4
Admin --> UC5

UC3 ..> UC2 : <<include>>
@enduml

```

## 活动图 (Activity Diagram) - Beta 语法
```plantuml
@startuml
left to right direction
actor "顾客" as Customer
actor "管理员" as Admin

rectangle "在线书店系统" {
    usecase "浏览书籍" as UC1
    usecase "搜索书籍" as UC2
    usecase "下单购买" as UC3
    usecase "管理库存" as UC4
    usecase "查看报表" as UC5
}

Customer --> UC1
Customer --> UC2
Customer --> UC3

Admin --> UC4
Admin --> UC5

UC3 ..> UC2 : <<include>>
@enduml

```

## 状态图 (State Diagram)
```plantuml
@startuml
state "空闲" as Idle
state "运行中" as Running
state "暂停" as Paused
state "结束" as End

[*] --> Idle
Idle --> Running : 启动
Running --> Paused : 暂停
Paused --> Running : 继续
Running --> End : 完成
End --> [*]

note right of Running
    此时CPU占用率高
end note
@enduml

```

## 组件图 (Component Diagram)
```plantuml
@startuml
package "Web层" {
    [浏览器] --> [Nginx]
}

package "应用层" {
    [Nginx] --> [API Gateway]
    [API Gateway] --> [用户服务]
    [API Gateway] --> [订单服务]
}

package "数据层" {
    [用户服务] --> [MySQL主库]
    [订单服务] --> [MySQL主库]
    [用户服务] ..> [Redis缓存]
}

cloud "外部服务" {
    [订单服务] --> [支付宝接口]
}
@enduml

```

## 部署图 (Deployment Diagram)
```plantuml
@startuml
package "Web层" {
    [浏览器] --> [Nginx]
}

package "应用层" {
    [Nginx] --> [API Gateway]
    [API Gateway] --> [用户服务]
    [API Gateway] --> [订单服务]
}

package "数据层" {
    [用户服务] --> [MySQL主库]
    [订单服务] --> [MySQL主库]
    [用户服务] ..> [Redis缓存]
}

cloud "外部服务" {
    [订单服务] --> [支付宝接口]
}
@enduml

```
