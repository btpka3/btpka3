## 远程调试
```
java -Dcom.sun.management.jmxremote.port=3333 \
     -Dcom.sun.management.jmxremote.ssl=false \
     -Dcom.sun.management.jmxremote.authenticate=false \
     -Djava.rmi.server.hostname=10.1.10.104\
     YourJavaApp
```


## 开发用信任证书
```
java -Djavax.net.ssl.trustStore=/path/to/your.keystore\
     -Djavax.net.ssl.trustStorePassword=123456\
     YourJavaApp
```