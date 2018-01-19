```java
package me.test;

import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.AmqpException;
import org.springframework.amqp.core.AmqpAdmin;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.core.MessagePostProcessor;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.ReceiveAndReplyCallback;
import org.springframework.amqp.rabbit.connection.CachingConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitAdmin;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.rabbit.core.RabbitTemplate.ConfirmCallback;
import org.springframework.amqp.rabbit.core.RabbitTemplate.ReturnCallback;
import org.springframework.amqp.rabbit.support.CorrelationData;

public class Sync {
    private static final String EXCHANGE_NAME = "my-sync-exchange";
    private static final String QUEUE_NAME = "my-sync-queue";
    private static final Random random = new Random(System.currentTimeMillis());

    public static void main(String[] args) {

        // init ConnectionFactory
        CachingConnectionFactory connectionFactory = new CachingConnectionFactory("localhost");
        connectionFactory.setUsername("guest");
        connectionFactory.setPassword("guest");

        // declare queue
        AmqpAdmin admin = new RabbitAdmin(connectionFactory);
        Queue queue = new Queue(QUEUE_NAME);
        admin.declareQueue(queue);

        DirectExchange exchange = new DirectExchange(EXCHANGE_NAME);
        admin.declareExchange(exchange);

        Binding binding = BindingBuilder.bind(queue).to(exchange).with("");
        admin.declareBinding(binding);

        A a1 = new A("a1");
        a1.start();
        A a2 = new A("a2");
        // a2.start();

        B b1 = new B("b1");
        b1.start();
        B b2 = new B("b2");
        // b2.start();
    }

    private static class A extends Thread {
        private static final Logger log = LoggerFactory.getLogger(A.class);

        public A(String name) {
            super(name);
        }

        public void run() {
            CachingConnectionFactory connectionFactory = new CachingConnectionFactory("localhost");
            connectionFactory.setUsername("guest");
            connectionFactory.setPassword("guest");
            connectionFactory.setPublisherConfirms(true);
            connectionFactory.setPublisherReturns(true);

            AmqpAdmin amqpAdmin = new RabbitAdmin(connectionFactory);
            Queue replyQueue = amqpAdmin.declareQueue();

            RabbitTemplate template = new RabbitTemplate(connectionFactory);
            template.setReplyQueue(replyQueue);
            template.setReturnCallback(new ReturnCallback() {

                public void returnedMessage(Message message, int replyCode, String replyText,
                        String exchange, String routingKey) {
                    log.debug(getName() + "#ReturnCallback : message=\"{}\", replyCode={}, "
                            + "replayText={}, exchange={}, routingKey={}",
                            message, replyCode, replyText, exchange, routingKey);
                }
            });
            template.setConfirmCallback(new ConfirmCallback() {

                public void confirm(CorrelationData correlationData, boolean ack) {
                    log.debug(getName() + "#ConfirmCallback : correlationData={}, ack={}",
                            correlationData, ack);
                }
            });

            int i = 0;
            while (!Thread.interrupted() && i < 1) {

                String msg = "msg-" + getName() + "-" + i;
                Object replyMsg = template.convertSendAndReceive(EXCHANGE_NAME, "", msg, new MessagePostProcessor() {

                    public Message postProcessMessage(Message message) throws AmqpException {
                        log.debug(getName() + "#MessagePostProcessor : msg \"{}\" ", message);
                        return message;
                    }

                });
                if (replyMsg == null) {
                    replyMsg = template.receiveAndConvert(replyQueue.getName());
                    while (replyMsg == null) {
                        replyMsg = template.receiveAndConvert(replyQueue.getName());
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                }
                log.debug(getName() + "# sending msg \"{}\" and receive msg \"{}\"", msg, replyMsg);
                i++;

                try {
                    Thread.sleep(random.nextInt(800) + 200);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    break;
                }
            }
        }
    }

    private static class B extends Thread {
        private static final Logger log = LoggerFactory.getLogger(B.class);

        public B(String name) {
            super(name);
        }

        public void run() {
            CachingConnectionFactory connectionFactory = new CachingConnectionFactory("localhost");
            connectionFactory.setUsername("guest");
            connectionFactory.setPassword("guest");
            connectionFactory.setPublisherConfirms(true);
            connectionFactory.setPublisherReturns(true);
            RabbitTemplate template = new RabbitTemplate(connectionFactory);
            template.setReturnCallback(new ReturnCallback() {

                public void returnedMessage(Message message, int replyCode, String replyText,
                        String exchange, String routingKey) {
                    log.debug(getName() + "#ReturnCallback : message=\"{}\", replyCode={}, "
                            + "replayText={}, exchange={}, routingKey={}",
                            message, replyCode, replyText, exchange, routingKey);
                }
            });
            template.setConfirmCallback(new ConfirmCallback() {

                public void confirm(CorrelationData correlationData, boolean ack) {
                    log.debug(getName() + "#ConfirmCallback : correlationData={}, ack={}",
                            correlationData, ack);
                }
            });

            while (!Thread.interrupted()) {

                boolean received = template.receiveAndReply(QUEUE_NAME, new ReceiveAndReplyCallback<String, String>() {

                    public String handle(String payload) {
                        String replyMsg = payload + "_" + getName();
                        log.debug(getName() + "#ReceiveAndReplyCallback : receiving msg \"{}\" and reply \"{}\" ",
                                payload,
                                replyMsg);
                        try {
                            Thread.sleep(random.nextInt(800) + 200);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                        return replyMsg;
                    }

                });
                if (!received) {
                    try {
                        Thread.sleep(random.nextInt(800) + 200);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                        break;
                    }
                }

            }
        }

    }

}

```