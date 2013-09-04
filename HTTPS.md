## KeyTool 和 OpenSSL 相互转换 
```bat
REM 生成自签名 CA 证书
REM Win32 OpenSSL
REM http://slproweb.com/products/Win32OpenSSL.html
REM How to create a self-signed SSL Certificate
REM http://www.akadia.com/services/ssh_test_certificate.html
REM OpenSSL to Keytool Conversion tips
REM http://conshell.net/wiki/index.php/OpenSSL_to_Keytool_Conversion_tips
REM X.509
REM http://en.wikipedia.org/wiki/X.509#Certificate_filename_extensions
REM ===================================== OpenSSL 2 KeyTools
REM 0. 一个命令就生成自签名的 CA 证书
REM openssl req -x509 -newkey rsa:1024 -passout pass:123456 -days 3650 -keyout whhit.pem.key -out whhit.pem.cer -subj "/CN=whhit.me/OU=WeRun Club/O=whhit/L=Weihai/S=Shandong/C=CN"
REM 1. 生成一个新的私钥
openssl genrsa -des3 -out whhit.pem.key -passout pass:123456 1024
REM 2. 使用指定的私钥生成一个CSR (Certificate Signing Request)
openssl req -new -key whhit.pem.key -passin pass:123456 -out whhit.pem.csr -subj "/CN=whhit.me/OU=WeRun Club/O=whhit/L=Weihai/S=Shandong/C=CN"
REM 3. 将加密的私钥导出为明文的私钥
openssl rsa -in whhit.pem.key -passin pass:123456 -out whhit.pem.clear.key
REM 4. 使用指定的私钥签名生成证书
openssl x509 -req -days 3650 -in whhit.pem.csr -signkey whhit.pem.clear.key -out whhit.pem.cer
REM 5. 将私钥和证书转化为 PKCS#12 格式的单个文件
openssl pkcs12 -export -in whhit.pem.cer -inkey whhit.pem.key -passin pass:123456 -out whhit.p12 -passout pass:123456 -name tomcat
REM 6. 使用 KeyTools 将 PKSC#12 文件导入为 JKS 的 KeyStore
keytool -importkeystore -srcstoretype PKCS12 -srckeystore whhit.p12 -srcstorepass 123456 -srcalias tomcat -srckeypass 123456 -deststoretype JKS -destkeystore whhit.jks -deststorepass 123456 -destalias tomcat -destkeypass 123456
REM ===================================== KeyTools 2 OpenSSL
REM 1. 生成一个含自签名 CA 证书的 JKS 类型的 KeyStore
keytool -genkeypair -alias tomcat -keyalg RSA -keysize 1024 -sigalg SHA1withRSA -dname "CN=test.me, OU=R & D department, O=\\"BJ SOS Software Tech Co., Ltd\\", L=Beijing, S=Beijing, C=CN" -validity 3650 -keypass 123456 -keystore sos.jks -storepass 123456
REM 2. 从 KeyStore 中导出证书
REM keytool -exportcert -rfc -file sos.pem.cer -alias tomcat -keystore sos.jks -storepass 123456
REM 3. 将 KeyStore 变更为 PKCS#12 格式
keytool -importkeystore -srcstoretype JKS -srckeystore sos.jks -srcstorepass 123456 -srcalias tomcat -srckeypass 123456 -deststoretype PKCS12 -destkeystore sos.p12 -deststorepass 123456 -destalias tomcat -destkeypass 123456 -noprompt
REM 4. 使用 OpenSSL 解析 PKCS#12 格式的 KeyStore，并转化为 PEM 格式(包含证书和私钥)
openssl pkcs12 -in sos.p12 -out sos.pem.p12 -passin pass:123456 -passout pass:123456
REM 5. 单独输出私钥和公钥
openssl rsa -in sos.pem.p12 -passin pass:123456 -out sos.pem.key -passout pass:123456
openssl rsa -in sos.pem.p12 -passin pass:123456 -out sos.pem.pub -pubout
REM 6. 单独输出证书
openssl x509 -in sos.pem.p12 -out sos.pem.cer
```

## Apahce 配置 HTTPS
1. 修改apache的配置文件 conf/httpd.conf，启用以下两句
```conf
LoadModule ssl_module modules/mod_ssl.so
Include conf/extra/httpd-ssl.conf
```
2. 修改apache的配置文件 conf/extra/httpd-ssl.conf, 修改一下两个指令所指向的路径
   * SSLCertificateFile ：应当指向上述使用openssl生成自签名证书时生成的 *.pem.cer
   * SSLCertificateKeyFile ：应当指向上述使用openssl生成自签名证书时生成的 *.pem.clear.key
3. 重启Apache，并将证书安装到IE“受信任的根证书”区域即可。

## 对子域名使用wildcard证书示例

示例环境：Windows + JDK 1.6 + Tomcat 6

1.  修改 C:\Windows\System32\drivers\etc\hosts，追加以下设置：
    ```
127.0.0.1       cas.localhost.me
127.0.0.1       app.localhost.me
127.0.0.1       stateless.localhost.me
    ```
    注意：经测试发现WildCard证书无法对 `*.localhost` 起作用。而 `*.localhost.me` 也无法对 `a.b.localhost.me` 起作用，参见[这里](http://security.stackexchange.com/a/26050)。

2.  生成自签名的数字证书
    1. 针对子域名
```
keytool -genkeypair -alias mykey2 -keyalg RSA -keysize 1024 -sigalg SHA1withRSA ^
-dname "CN=*.localhost.me, OU=R & D department, O=\\"ABC Tech Co., Ltd\\", L=Weihai, S=Shandong, C=CN" ^
-validity 365 -keypass 123456 -keystore tomcat.keystore -storepass 123456
```
    注意：其中CN是域名。-keypass 和 -storepass tomcat貌似是要求一致的。  
    2. 针对IP地址
```
keytool -genkeypair -alias mykey2 -keyalg RSA -keysize 1024 -sigalg SHA1withRSA ^
-dname "CN=10.1.18.123, OU=R & D department, O=\\"ABC Tech Co., Ltd\\", L=Weihai, S=Shandong, C=CN" ^
-ext SAN=IP:10.1.18.123 ^
-validity 365 -keypass 123456 -keystore tomcat.keystore -storepass 123456
```
    注意：`-ext` 选项是 [JDK 7](http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/keytool.html) 中新增选项  
    其中CN也应该为IP地址。
3.  导出证书
```
keytool -exportcert -rfc -file localhost.me.cer -alias mykey2 -keystore tomcat.keystore -storepass 123456
```

4.  将导出的证书安装到：受信任的根证书颁发机构
5.  配置Tomcat启用HTTPS。${CATALINA_HOME}/conf/server.xml：
```xml
<Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
               maxThreads="150" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS"
               keystoreFile="D:/tomcat.keystore"
               keystorePass="123456"/>
```
6.  为tomcat指定JVM启动参数
    1.  如果在 Eclipse中启动Tomcat，则需要追加JVM参数：
        ```
-Djavax.net.ssl.trustStore="D:\tomcat.keystore" -Djavax.net.ssl.trustStorePassword="123456"
        ```
    2.  如果需要单独启动tomcat，则在 %CATALINA_HOME%/bin/catalina.bat 开头追加：
        ```
  JAVA_OPTS = -Djavax.net.ssl.trustStore="D:\tomcat.keystore" -Djavax.net.ssl.trustStorePassword="123456"
        ```
7.  启动Tomcat后通过IE、Chrome访问以下网址均不会报证书错误：（Firefox有独立的证书设定）
    ```
https://cas.localhost.me:8443/
https://app.localhost.me:8443/
https://stateless.localhost.me:8443/
    ```


## keytool 合并两个keystore
```
keytool -importkeystore -srckeystore src.keystore -srcstorepass 123456 -destkeystore dest.keystore -deststorepass 123456
```