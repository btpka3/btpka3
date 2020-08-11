
# 参考
- [spring integration reference](https://docs.spring.io/spring-integration/docs/4.3.9.RELEASE/reference/htmlsingle/#channel-implementations-publishsubscribechannel)
- [Messaging Patterns Overview](https://www.enterpriseintegrationpatterns.com/patterns/messaging/)
- [spring-integration-samples](https://github.com/spring-projects/spring-integration-samples)

# org.springframework.messaging.Message
代表一个消息。


# org.springframework.messaging.MessageChannel
代表 pipes-and-filters 架构中的 pipe， 级联进行不同的处理。

- interface: MessageChannel ： 只能发送消息
- interface: PollableChannel： 是  MessageChannel 的子接口，既可以发送消息，也可以通过轮询的方式 接收消息。
    - NullChannel
    - QueueChannel
        - PriorityChannel
        - RendezvousChannel : 内部使用 SynchronousQueue，只能一个消息一个消息处理。
- interface: SubscribableChannel ：是  MessageChannel 的子接口，既可以发送消息，也可以通过 subscribe 的方式 订阅 消息。
    - DirectChannel: 针对每个消息，单点消费一次， SYNC 消费, 内部使用 UnicastingDispatcher
    - ExecutorChannel: 针对每个消息，单点消费一次， ASYNC 消费, 内部使用 UnicastingDispatcher
    - PublishSubscribeChannel: 内部使用 BroadcastingDispatcher

    - ExecutorSubscribableChannel: 让关联的 MessageHandler 在 executor 中消费消息。
         FIXME: 与 PublishSubscribeChannel 的差别是 ???
    - FixedSubscriberChannel: 关联的 MessageHandler 是固定的，不允许变更


# org.springframework.integration.endpoint.AbstractEndpoint
类似 MVC 中的 Controller。
主要就是 start/stop 等方法，内部做的了什么逻辑依赖具体实现。

- IntegrationConsumer
- AbstractPollingEndpoint
    - PollingConsumer : 关联 PollableChannel+MessageHandler
    - SourcePollingChannelAdapter : 关联 MessageSource+ MessageChannel
- EventDrivenConsumer : 关联 SubscribableChannel+MessageHandler
- ReactiveStreamsConsumer : 关联 MessageChannel+ReactiveMessageHandler
- MessageProducerSupport

# org.springframework.messaging.MessageHandler
对一个消息进行各种处理， 是一个基础的接口, 无返回值。
其实现类通常也要同时实现  MessageProducer（主动编程处理） 或者 MessageRouter(默认) 等接口。

- interface : org.springframework.web.socket.messaging.SubProtocolHandler
- interface : org.springframework.integration.handler.DiscardingMessageHandler
- SimpAnnotationMethodMessageHandler:  识别并处理  @MessageMapping, @SubscribeMapping 方法
- ReactiveMessageHandler
- StompBrokerRelayMessageHandler : 将消息 发送到 STOMP broker
- SubProtocolWebSocketHandler : 将从 webSocket 收到的消息发送到 高层的协议 处理。
- UserDestinationMessageHandler :
- UserRegistryMessageHandler

- org.springframework.web.socket.WebSocketHandler
- WebSocketAnnotationMethodMessageHandler : SimpAnnotationMethodMessageHandler 的子类， 识别并处理 @MessageExceptionHandler 方法。

- interface: org.springframework.integration.handler.PostProcessingMessageHandler
- MessageFilter


# org.springframework.integration.handler.MessageProcessor
对消息进行类型转换。返回值可以是任何类型。
- BeanNameMessageProcessor
- ExpressionCommandMessageProcessorMessageChannel
- ScriptExecutingMessageProcessor

# org.springframework.integration.router.MessageRouter
- ExpressionEvaluatingRouter
# org.springframework.integration.IntegrationPatternType


# org.springframework.integration.core.MessageSource
轮询获取消息。
- JdbcPollingChannelAdapter
- RedisStoreMessageSource
- MethodInvokingMessageSource

# org.springframework.integration.core.MessageSelector
判断是否能支持接收一个消息。

# org.springframework.integration.core.MessageProducer
关联一个 output MessageChannel, 并发送消息

# org.springframework.messaging.core.DestinationResolver

- BeanFactoryChannelResolver : 按照 名称 从 HeaderChannelRegistry 中 获取 MessageChannel
- BeanFactoryMessageChannelDestinationResolver :  简单的 spring 上下文中按照 bean 的 名称获取bean

# org.springframework.integration.dispatcher.MessageDispatcher
可以关联多个 MessageHandler， 然后将消息转发到这些 MessageHandler 上。

- UnicastingDispatcher: 只要关联的任意一个 MessageHandler 处理成功，就立即结束
- BroadcastingDispatcher: 会将关联的 MessageHandler 都消费消息一次。

# org.springframework.integration.core.MessagingTemplate


# org.springframework.integration.splitter.AbstractMessageSplitter
# org.springframework.integration.aggregator.AggregatingMessageHandler
# org.springframework.integration.handler.MessageHandlerChain
# org.springframework.integration.scattergather.ScatterGatherHandler
# org.springframework.integration.aggregator.BarrierMessageHandler
# org.springframework.integration.transformer.MessageTransformingHandler
# ApplicationEventPublishingMessageHandler

# annotation
[Annotation Support](https://docs.spring.io/spring-integration/docs/5.3.1.RELEASE/reference/html/configuration.html#annotations)

- @InboundChannelAdapter
    <int-file:inbound-channel-adapter/>
    @see org.springframework.integration.file.config.FileInboundChannelAdapterParser

- @Splitter
- @Gateway
- @MessagingGateway
- @Payload
- @ServiceActivator
    <int:service-activator
- @Poller
    <int:poller/>

- <int:channel>
    @see org.springframework.integration.config.xml.PointToPointChannelParser
    @see org.springframework.integration.channel.QueueChannel
    @see org.springframework.integration.channel.PriorityChannel
    @see org.springframework.integration.channel.RendezvousChannel
    @see org.springframework.integration.channel.FixedSubscriberChannel
    @see org.springframework.integration.channel.ExecutorChannel
    @see org.springframework.integration.channel.DirectChannel


# org.springframework.messaging.support.ChannelInterceptor
- WireTap : preSend 中，将消息发送到 别的 MessageChannel 中，但不中断当前 消息流。
# ChannelSecurityInterceptor

# org.springframework.integration.support.converter.DefaultDatatypeChannelMessageConverter

# org.springframework.integration.transformer.Transformer
- JsonToObjectTransformer
- ObjectToJsonTransformer
- MapToObjectTransformer
- ObjectToMapTransformer
- HeaderFilter
- StreamTransformer
- HeaderEnricher
- ??? ContentEnricher
- ClaimCheckInTransformer
- EncodingPayloadTransformer
- DecodingTransformer
- CodecMessageConverter

