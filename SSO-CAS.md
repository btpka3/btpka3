## 允许所有的URL接收ST
http://static.springsource.org/spring-security/site/docs/3.1.x/reference/springsecurity-single.html#cas-pt
1.  serviceProperties
    *   设置 authenticateAllArtifacts = true
2.  casAuthenticationFilter
    *   指定 serviceProperties
    *   指定 authenticationDetailsSource
    *   （可选）指定proxyGrantingTicketStorage
3.  casProcessingFilterEntryPoint
    *   指定 serviceProperties
    *   （可选）指定 ticketValidator 为 Cas20ProxyTicketValidator
    *   （可选）指定 statelessTicketCache