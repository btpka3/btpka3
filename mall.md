# 相关概念篇

* DSP - Demand-Side Platform : [wikipedia](http://en.wikipedia.org/wiki/Demand-side_platform)、 [baidu](http://baike.baidu.com/view/8103074.htm)

* SSP - Supply-side platform : [wikipedia](http://en.wikipedia.org/wiki/Supply-side_platform)



# 第三方支付篇

* [中国银联](https://www.95516.com/)：[资料](https://merchant.unionpay.com/portal/pages/login/download.jsp?locale=zh_CN)

* [网银在线](http://www.chinabank.com.cn/)：[资料](http://www.chinabank.com.cn/gateway/help.jsp)


# 第三方登录篇

# 短信

* [亿美](http://www.emay.cn/)、[资料](http://www.emay.cn/down.htm)




# cdn

```
User                        DNS Server1                                   DNS Server2
 |  1. lookup "cdn.test.me"   |                                             |
 | -------------------------> |                                             |
 |                            | 2. found CNAME : cdn.test.me.xx-cdn.cn      |
 |                            | 3. lookup "cdn.test.me.xx-cdn.cn"           |
 |                            | ------------------------------------------> |
 |                            |                                             | 4. found A: x.x.x.x
 |                            |                                             |    found A: y.y.y.y
 |                            |         5. base on client ip, return one ip |
 |                            | <------------------------------------------ | 
 |          6. return cdn ip  |                                             |
 | <------------------------- |                                             |
```
