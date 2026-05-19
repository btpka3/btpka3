

# 示例

## 类图
```mermaid
classDiagram
    class Animal {
        +String name
        +int age
        +makeSound() void
    }
    class Dog {
        +fetch() void
    }
    class Cat {
        +climb() void
    }
    Animal <|-- Dog
    Animal <|-- Cat
```

## 时序图
```mermaid
sequenceDiagram
    participant User
    participant System
    participant Database
    User->>System: Login Request
    System->>Database: Query User
    Database-->>System: User Data
    System-->>User: Login Success

```

## 活动图
```mermaid
flowchart TD
    Start([Start]) --> Process1[Process A]
    Process1 --> Decision{Is Valid?}
    Decision -- Yes --> Process2[Process B]
    Decision -- No --> End([End])
    Process2 --> End
```

## 状态图
```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing : Start
    Processing --> Success : Complete
    Processing --> Error : Fail
    Success --> [*]
    Error --> Idle : Retry
```

## 组件图
```mermaid
C4Component
    Container_Boundary(c1, "Web Application") {
        Component(comp1, "API Controller", "Java Spring", "Handles HTTP requests")
        Component(comp2, "Service Layer", "Java", "Business logic")
        ComponentDb(comp3, "Database", "SQL", "Stores data")
    }
    Rel(comp1, comp2, "Uses")
    Rel(comp2, comp3, "Reads/Writes")

```

## ER 图
```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains
    CUSTOMER {
        string name
        string email
    }
    ORDER {
        int id
        date orderDate
    }
    LINE_ITEM {
        int quantity
        float price
    }

```

## Sankey 图
```mermaid
sankey-beta
    Source A,Target X,50
    Source A,Target Y,30
    Source B,Target X,20
    Source B,Target Z,40
    Target X,Final Output,60
    Target Y,Final Output,30
    Target Z,Waste,40

```



## 象限图示例: 任务优先级管理

```mermaid
quadrantChart
    title 任务优先级矩阵
    x-axis "不紧急" --> "紧急"
    y-axis "不重要" --> "重要"
    quadrant-1 "立即去做\n(重要且紧急)"
    quadrant-2 "计划去做\n(重要不紧急)"
    quadrant-3 "授权去做\n(紧急不重要)"
    quadrant-4 "尽量不做\n(不重不急)"

    "修复线上Bug": [0.9, 0.9]
    "季度战略规划": [0.2, 0.9]
    "回复无关邮件": [0.8, 0.1]
    "刷社交媒体": [0.1, 0.1]
    "准备下周会议": [0.6, 0.7]
    "整理桌面文件": [0.3, 0.3]
```


## 思维导图示例： 项目管理核心领域

```mermaid
mindmap
  root((项目管理))
    范围管理
      需求收集
      WBS分解
      范围确认
    时间管理
      活动定义
      进度计划
      关键路径法
    成本管理
      资源估算
      预算制定
      成本控制
    质量管理
      质量规划
      质量保证
      质量控制
    风险管理
      风险识别
      定性分析
      应对策略
```


## 饼图示例: IT 项目年度预算分配

```mermaid
pie title 2025 IT 部门预算分布
    "人力成本" : 45.5
    "云服务费用" : 25.0
    "软件授权" : 15.5
    "硬件采购" : 10.0
    "培训与团建" : 4.0
```


## 甘特图示例: Q4 软件发布计划

```mermaid
gantt
    title Q4 核心功能发布计划
    dateFormat  YYYY-MM-DD
    axisFormat  %m/%d

    section 需求与设计
    需求调研       :done,    des1, 2023-10-01, 7d
    UI/UX 设计     :active,  des2, after des1, 5d
    技术架构评审   :         des3, after des2, 3d

    section 后端开发
    数据库建模     :crit,    dev1, after des3, 4d
    API 接口开发   :crit,    dev2, after dev1, 10d
    单元测试编写   :         dev3, after dev2, 5d

    section 前端开发
    页面组件开发   :         fe1, after des2, 8d
    接口联调       :         fe2, after dev2, 6d

    section 测试与发布
    集成测试       :         test1, after fe2, 5d
    Bug 修复       :         test2, after test1, 4d
    正式上线       :milestone, m1, after test2, 0d
```


## Git Flow 发布与热修复

```mermaid
gitGraph
    %% 初始化主分支
    commit id: "v1.0.0" tag: "v1.0.0"

    %% 创建开发分支
    branch develop
    checkout develop
    commit id: "Feat A"
    commit id: "Feat B"

    %% 创建发布分支
    branch release/v1.1
    checkout release/v1.1
    commit id: "Prepare Release"

    %% 模拟发现 Bug，在 release 分支修复
    commit id: "Fix Release Bug"

    %% 合并回 develop 和 main
    checkout develop
    merge release/v1.1

    checkout main
    merge release/v1.1 tag: "v1.1.0"

    %% 模拟线上紧急 Bug (Hotfix)
    branch hotfix/critical
    checkout hotfix/critical
    commit id: "Critical Fix"

    checkout main
    merge hotfix/critical tag: "v1.1.1"

    checkout develop
    merge hotfix/critical
```


## 用户旅行图


```mermaid
journey
    title 用户在线购物体验旅程
    section 浏览与发现
      搜索商品: 4: 用户
      查看商品详情: 3: 用户
      阅读用户评论: 5: 用户
    section 下单与支付
      加入购物车: 5: 用户
      填写收货地址: 2: 用户
      选择支付方式: 3: 用户
      完成支付: 4: 用户, 银行系统
    section 物流与售后
      等待发货: 2: 用户
      查看物流轨迹: 3: 用户
      签收包裹: 5: 用户, 快递员
      评价商品: 4: 用户
```



## 流程图
```mermaid
graph TD
    A[开始] --> B{判断}
    B -->|是| C[处理]
    B -->|否| D[结束]
```

## 时间线图
```mermaid
timeline
    title [你的标题]
    section [第一阶段]
        [时间1] : [事件1]
        [时间2] : [事件2]
    section [第二阶段]
        [时间3] : [事件3]
        [时间4] : [事件4]
```


## zenuml 示例

```mermaid
zenuml
    Title Place Order Process

    Customer -> Frontend: click "Buy Now"
    Frontend -> OrderService: createOrder(items, userId)

    OrderService -> InventoryService: checkStock(items)

    loop for each item in items
        InventoryService -> Database: select stock from products
        Database --> InventoryService: stockCount

        alt stock > 0
            InventoryService --> OrderService: OK
        else out of stock
            InventoryService --> OrderService: Error: Out of Stock
            break
        end
    end

    OrderService -> PaymentService: charge(userId, amount)
    PaymentService --> OrderService: paymentSuccess

    OrderService -> Database: insert order record
    Database --> OrderService: orderId

    OrderService --> Frontend: Order Created (id: 12345)
    Frontend --> Customer: Show Success Page
```

### 时序图

```mermaid
zenuml
    title Online shopping
    @Actor Customer
    Customer->Website.browse() {
    BackEnd.loadProducts
    }
    Customer->Website.addToCart(p1, p2) {
    BackEnd.updateCart
    }
    Customer->Website.submitOrder(p1, p2) {
    BackEnd.createOrder
    }

    Customer->Website.checkout(paymentInfo) {
    BackEnd.checkout(paymentInfo) {
        result = PaymentGateway.processPaymentInfo()
        updateOrder(result)
        if (result == success) {
        DeliverySystem.register()

        DeliverySystem->Customer: Deliver the order
        } else {
        return rejected
        @return Website->Customer: rejected
        }
    }
    }
```





