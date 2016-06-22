# 免费的https证书
* [WoSign](http://freessl.wosign.com/freessl)
* [Let's Encrypt](https://letsencrypt.org/)  就是时间短了点,需要3个月renew一下.
* [startssl.com](https://www.startssl.com/)



## KeyTool 和 OpenSSL 相互转换 
参考：

* [Win32 OpenSSL](http://slproweb.com/products/Win32OpenSSL.html)
* 《[How to create a self-signed SSL Certificate](http://www.akadia.com/services/ssh_test_certificate.html)》
* [OpenSSL to Keytool Conversion tips](http://conshell.net/wiki/index.php/OpenSSL_to_Keytool_Conversion_tips
REM X.509)
* http://en.wikipedia.org/wiki/X.509#Certificate_filename_extensions

### OpenSSL -> KeyTools

1. 一个命令就生成自签名的 CA 证书

    ```sh
    # 该命令仅供参考，后续命令会将该命令分解演示
    openssl req \
        -x509 \
        -newkey rsa:1024 \
        -passout pass:123456 \
        -days 3650 \
        -keyout whhit.pem.key \
        -out whhit.pem.cer \
        -subj "/CN=whhit.me/OU=WeRun Club/O=whhit/L=Weihai/S=Shandong/C=CN"
    ```
1. 生成一个新的私钥
  
    ```sh
    openssl genrsa -des3 -out whhit.pem.key -passout pass:123456 1024
    ```
1. 使用指定的私钥生成一个CSR (Certificate Signing Request)

    ```sh
    openssl req \
        -new \
        -key whhit.pem.key \
        -passin pass:123456 \
        -out whhit.pem.csr \
        -subj "/CN=whhit.me/OU=WeRun Club/O=whhit/L=Weihai/S=Shandong/C=CN"
    ```
1. 将加密的私钥导出为明文的私钥

    ```sh
    openssl rsa -in whhit.pem.key -passin pass:123456 -out whhit.pem.clear.key
    ```
1. 使用指定的私钥签名生成证书

    ```sh
    openssl x509 \
        -req \
        -days 3650 \
        -in whhit.pem.csr \
        -signkey whhit.pem.clear.key \
        -out whhit.pem.cer
    ```
1. 将私钥和证书转化为 PKCS#12 格式的单个文件

    ```sh
    openssl pkcs12 \
        -export \
        -in whhit.pem.cer \
        -inkey whhit.pem.key \
        -passin pass:123456 \
        -out whhit.p12 \
        -passout pass:123456 \
        -name tomcat
    ```
1. 使用 KeyTools 将 PKSC#12 文件导入为 JKS 的 KeyStore

    ```sh
    keytool -importkeystore \
        -srcstoretype PKCS12 \
        -srckeystore whhit.p12 \
        -srcstorepass 123456 \
        -srcalias tomcat \
        -srckeypass 123456 \
        -deststoretype JKS \
        -destkeystore whhit.jks \
        -deststorepass 123456 \
        -destalias tomcat \
        -destkeypass 123456
    ```

## KeyTools -> OpenSSL

1. 生成一个含自签名 CA 证书的 JKS 类型的 KeyStore

    ```sh
    keytool -genkeypair \
        -alias tomcat \
        -keyalg RSA \
        -keysize 1024 \
        -sigalg SHA1withRSA \
        -dname "CN=test.me, OU=R & D department, O=\"BJ SOS Software Tech Co., Ltd\", L=Beijing, S=Beijing, C=CN" \
        -validity 3650 \
        -keypass 123456 \
        -keystore sos.jks \
        -storepass 123456
     ```
1. 从 KeyStore 中导出证书

     ```sh
     keytool -exportcert \
         -rfc \
         -file sos.pem.cer \
         -alias tomcat \
         -keystore sos.jks \
         -storepass 123456
     ```
1. 将 KeyStore 变更为 PKCS#12 格式

    ```sh
    keytool -importkeystore \
        -srcstoretype JKS \
        -srckeystore sos.jks \
        -srcstorepass 123456 \
        -srcalias tomcat \
        -srckeypass 123456 \
        -deststoretype PKCS12 \
        -destkeystore sos.p12 \
        -deststorepass 123456 \
        -destalias tomcat \
        -destkeypass 123456 \
        -noprompt
    ```
1. 使用 OpenSSL 解析 PKCS#12 格式的 KeyStore，并转化为 PEM 格式(包含证书和私钥)

    ```sh
    openssl pkcs12 \
        -in sos.p12 \
        -out sos.pem.p12 \
        -passin pass:123456 \
        -passout pass:123456
    ```
1. 单独输出私钥和公钥

    ```sh
    # 私钥
    openssl rsa \
        -in sos.pem.p12 \
        -passin pass:123456 \
        -out sos.pem.key \
        -passout pass:123456
    # 明文私钥
    openssl rsa \
        -in sos.pem.key \
        -passin pass:123456 \
        -out sos.pem.clear.key


    # 公钥
    openssl rsa \
        -in sos.pem.p12 \
        -passin pass:123456 \
        -out sos.pem.pub \
        -pubout
    ```
1. 单独输出证书

    ```sh
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

## 使用PUTTYgen 生成SSH密钥
参考[这里](http://stackoverflow.com/questions/2224066/how-to-convert-ssh-keypairs-generated-using-puttygenwindows-into-key-pairs-use)，使用以下步骤：

1. Open PuttyGen
2. Click Load
3. Load your private key
4. Go to Conversions->Export OpenSSH and export your private key
5. Copy your private key to ~/.ssh/id_dsa (or id_rsa).
6. Create the RFC 4716 version of the public key using ssh-keygen
   `ssh-keygen -i -f ~/.ssh/id_dsa_com.pub > ~/.ssh/id_dsa.pub`


# 生成SSH key

```sh
ssh-keygen -t rsa -C "hi@test.me" -N 'xxxPass' -f ~/.ssh/id_rsa
```


# 确认openssl是否已经修正了 Heatbleed

```sh
yum update
rpm -q --changelog openssl-1.0.1e | grep -B 1 CVE-2014-0160
rpm -q --changelog openssl-devel | grep -B 1 CVE-2014-0160
```


# jarsigner

## 签名


```
keytool -genkeypair \
    -alias btpka3 \
    -keyalg RSA \
    -keysize 1024 \
    -sigalg SHA1withRSA \
    -dname "CN=btpka3.github.io, OU=R&D, O=\"WeRun Club\", L=WeiHai, S=ShanDong, C=CN" \
    -validity 3650 \
    -keypass 123456 \
    -keystore sos.jks \
    -storepass 123456

jarsigner -keystore sos.jks \
    -storepass 123456 \
    -storetype jks \
    -keypass 123456 \
    -digestalg SHA1 \
    -sigalg SHA1withRSA \
    -tsa http://timestamp.digicert.com \
    -signedjar platforms/android/build/outputs/apk/android-release-signed.apk \
    platforms/android/build/outputs/apk/android-release-unsigned.apk \
    btpka3
```

## 验证

```
jarsigner -verify \
    -keystore sos.jks \
    -storetype jks \
    -tsa http://timestamp.digicert.com \
    -digestalg SHA1 \
    -sigalg SHA1withRSA \
    platforms/android/build/outputs/apk/android-release-signed.apk
```

说明:
微信开发者中心登记的app的签名其实是证书的 md5值 (小写,无冒号间隔) : 

```
# 方法1: 通过keytool 查看 Certificate fingerprints: 提示中的 MD5 值:
keytool -list -v -keystore sos.jks 

# 方法2: 通过keytool 查看 APK 压缩包中 META-INF目录下 RSA 文件
keytool -printcert -file path/to/xxx.apk/META-INF/PLATFORM.RSA 
```
