# 免费的https证书
* [~~WoSign~~](http://freessl.wosign.com/freessl) ——因操作不规范已经被要求整改，
火狐等浏览器也将 [移除](http://mozilla.com.cn/forum.php?mod=viewthread&tid=373719) 其相关证书。
* [Let's Encrypt](https://letsencrypt.org/)  就是时间短了点,需要3个月renew一下.
* [startssl.com](https://www.startssl.com/)
问: 各大https证书厂商推的 普通, DV, OV, EV 证书差别在何处?


# http2

[demo](https://http2.akamai.com/demo)

# to pem

```
openssl rsa -in ~/.ssh/id_rsa -outform pem > ~/.ssh/id_rsa.pem
```




## KeyTool 和 OpenSSL 相互转换
参考：

* [OpenSSL](https://www.openssl.org/docs/man1.1.0/apps/)
* [x509v3_config](https://www.openssl.org/docs/man1.1.0/apps/x509v3_config.html)
* [RabbitMQ SSL](http://www.rabbitmq.com/ssl.html)
* [Win32 OpenSSL](http://slproweb.com/products/Win32OpenSSL.html)
* 《[How to create a self-signed SSL Certificate](http://www.akadia.com/services/ssh_test_certificate.html)》
* [OpenSSL to Keytool Conversion tips](http://conshell.net/wiki/index.php/OpenSSL_to_Keytool_Conversion_tips
REM X.509)
* http://en.wikipedia.org/wiki/X.509#Certificate_filename_extensions
* [RDN, Relative Distinguished Names](https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol)


|name|desc|memo|
|---|---|---|
|CN| CommonName||
|OU| OrganizationalUnit||
|O| Organization||
|L| Locality||
|S| StateOrProvinceName||
|C| CountryName||

### OpenSSL -> KeyTools

1. 创建所需的配置文件 openssl.cnf


    ```
    [ req ]
    distinguished_name = root_ca_distinguished_name

    [ root_ca_distinguished_name ]
    commonName = hostname

    [ root_ca_extensions ]
    basicConstraints = CA:true
    keyUsage = keyCertSign, cRLSign

    [ client_ca_extensions ]
    basicConstraints = CA:false
    keyUsage = digitalSignature
    extendedKeyUsage = 1.3.6.1.5.5.7.3.2

    [ server_ca_extensions ]
    basicConstraints = CA:false
    keyUsage = keyEncipherment
    extendedKeyUsage = 1.3.6.1.5.5.7.3.1
    ```

1. 一个命令就生成自签名的 CA 证书

    ```bash
    # 该命令仅供参考，后续命令会将该命令分解演示
    openssl req \
        -x509 \
        -newkey rsa:2048 \
        -days 3650 \
        -sha256 \
        -config openssl.cnf \
        -extensions root_ca_extensions \
        -subj "/CN=whhit.me/OU=WeRun Club/O=whhit/L=Weihai/C=CN" \
        -outform PEM \
        -out whhit.pem.cer \
        -keyout whhit.pem.key \
        -nodes

        #-passout pass:123456
    ```

1. 生成一个新的私钥

    ```bash
    openssl genrsa \
        -out server.pem.key \
        2048

        #-passout pass:123456 \
    ```

1. 使用指定的私钥生成一个CSR (Certificate Signing Request)

    ```bash
    openssl req \
        -new \
        -key server.pem.key \
        -out server.pem.csr \
        -subj "/CN=btpka3.me/OU=WeRun Club/O=whhit/L=Weihai/C=CN"

        # -passin pass:123456 \
    # 可以使用 "-nodes" 选项使得在创建私钥时加密
    ```

1. 使用指定的私钥签名生成证书

    ```bash
    openssl x509 \
        -req \
        -days 3650 \
        -in server.pem.csr \
        -CA server.pem.cer \
        -CAkey server.pem.key \
        -CAcreateserial \
        -extfile openssl.cnf \
        -extensions server_ca_extensions \
        -out server.pem.cer

    # 或者
    openssl x509 \
        -req \
        -days 3650 \
        -in server.pem.csr \
        -signkey server.pem.key \
        -extfile openssl.cnf \
        -extensions server_ca_extensions \
        -out server.pem.cer

        # -passin pass:123456 \
    # 上述命令也可以使用 ca 子命令替换
    ```

1. 将私钥和证书转化为 PKCS#12 格式的单个文件

    ```bash
    openssl pkcs12 \
        -export \
        -in server.pem.cer \
        -inkey server.pem.key \
        -out server.p12 \
        -passout pass:123456 \
        -name server

        #-passin pass:123456 \
    ```

1. 使用 KeyTools 将 PKSC#12 文件导入为 JKS 的 KeyStore

    ```bash
    keytool -importkeystore \
        -srcstoretype PKCS12 \
        -srckeystore server.p12 \
        -srcstorepass 123456 \
        -srcalias tomcat \
        -srckeypass 123456 \
        -deststoretype JKS \
        -destkeystore server.jks \
        -deststorepass 123456 \
        -destalias tomcat \
        -destkeypass 123456
    ```


1. 其他命令

    ```bash
    # 将加密的私钥导出为明文的私钥
    openssl rsa \
        -in server.pem.key \
        -passin pass:123456 \
        -out server.pem.clear.key

    # PEM -> DER
    openssl x509 \
        -in server.pem.cer \
        -out server.der.cer \
        -outform DER

    # 显示证书信息
    openssl x509 \
        -in server.pem.cer \
        -text

    # 检验证书
    openssl verify \
        -verbose \
        -CAfile server.pem.cer \
        zll.pem.cer

    # 检查使用特定版本的 SSL/TLS 协议进行链接
    # 如果链接成功，通常可以输入 "GET /" 进行检测。
    openssl s_client \
        -ssl3 \
        -connect 127.0.0.1:5671
    ```

## KeyTools -> OpenSSL


0. 生成一个含自签名 CA 证书的 p12 类型的 KeyStore
     ```bash
     keytool -genkeypair \
         -alias tomcat \
         -keyalg RSA \
         -keysize 2048 \
         -sigalg SHA1withRSA \
         -dname "CN=test.me, OU=R & D department, O=\"BJ SOS Software Tech Co., Ltd\", L=Beijing, S=Beijing, C=CN" \
         -validity 3650 \
         -keystore sos.p12 \
         -storetype PKCS12 \
         -storepass 123456

      keytool -list -keystore sos.jks
      ```

1. 生成一个含自签名 CA 证书的 JKS 类型的 KeyStore

    ```bash
    keytool -genkeypair \
        -alias tomcat \
        -keyalg RSA \
        -keysize 1024 \
        -sigalg SHA1withRSA \
        -dname "CN=test.me, OU=R & D department, O=\"BJ SOS Software Tech Co., Ltd\", L=Beijing, S=Beijing, C=CN" \
        -validity 3650 \
        -keypass 456789 \
        -keystore sos.jks \
        -storepass 123456

     keytool -list -keystore sos.jks
     ```
1. 从 KeyStore 中导出证书

     ```bash
     keytool -exportcert \
         -rfc \
         -file sos.pem.cer \
         -alias tomcat \
         -keystore sos.jks \
         -storepass 123456
     ```
1. 将 KeyStore 变更为 PKCS#12 格式

    ```bash
    keytool -importkeystore \
        -srcstoretype JKS \
        -srckeystore sos.jks \
        -srcstorepass 123456 \
        -srcalias tomcat \
        -srckeypass 456789 \
        -deststoretype PKCS12 \
        -destkeystore sos.p12 \
        -deststorepass 123456 \
        -destalias tomcat \
        -destkeypass 123456 \
        -noprompt

    # 导出证书
    openssl pkcs12 \
        -in sos.p12 \
        -passin pass:123456 \
        -nokeys \
        -out sos.pem.cer

    openssl pkcs12 \
        -in sos.p12  \
        -passin pass:123456 \
        -nodes \
        -nocerts \
        -out sos.pem.key
    ```
1. 使用 OpenSSL 解析 PKCS#12 格式的 KeyStore，并转化为 PEM 格式(包含证书和私钥)

    ```bash
    openssl pkcs12 \
        -in sos.p12 \
        -out sos.pem.p12 \
        -passin pass:123456 \
        -nodes
    ```
1. 单独输出私钥和公钥  (注意：不是证书）

    ```bash
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

    ```bash
    openssl x509 -in sos.pem.p12 -out sos.pem.cer
    ```

## Apahce 配置 HTTPS
1. 修改apache的配置文件 conf/httpd.conf，启用以下两句
```groovy
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
    注意：经测试发现WildCard证书无法对 `*.localhost` 起作用。而 `*.localhost.me`
    也无法对 `a.b.localhost.me` 起作用，参见[这里](http://security.stackexchange.com/a/26050)。

2.  生成自签名的数字证书
    1. 针对子域名

        ```
        keytool -genkeypair -alias mykey2 -keyalg RSA \
            -keysize 1024 \
            -sigalg SHA1withRSA \
            -dname "CN=*.localhost.me, OU=R & D department, O=\\"ABC Tech Co., Ltd\\", L=Weihai, S=Shandong, C=CN" \
            -validity 365 \
            -keypass 123456 \
            -keystore tomcat.keystore -storepass 123456
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

```bash
keytool -importkeystore \
    -srckeystore src.keystore \
    -srcstorepass 123456 \
    -destkeystore dest.keystore \
    -deststorepass 123456
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

```bash
ssh-keygen -t rsa -C "hi@test.me" -N 'xxxPass' -f ~/.ssh/id_rsa
```


# 确认openssl是否已经修正了 Heartbleed

```bash
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


# 版本

```
# 检查版本
openssl version
yum info openssl

# 可以到 https://www.openssl.org/ 下载并编译安装
```


# 公钥私钥格式
X.509 ： 用于定义公钥的格式
DER ： 用于存储 X.509  证书、PKCS8 私钥等，但其是二级制格式，无法文本编辑器打开进行Review。
PKCS8 ： 用于定义私钥的格式
PEM ： 是 将 DER 内容 base-64 编码


## PKCS : Public-Key Cryptography Standards
- [PKCS](https://baike.baidu.com/item/PKCS/1042350?fr=aladdin)
- [PKCS #1: RSA Cryptography Specifications Version 2.2](https://datatracker.ietf.org/doc/html/rfc8017)
- [Public-Key Cryptography Standards (PKCS) #8:Private-Key Information Syntax Specification Version 1.2](https://datatracker.ietf.org/doc/html/rfc5208)
   PKCS#8 用以保存单个秘钥（不含公钥）
- [PKCS #12: Personal Information Exchange Syntax v1.1](https://datatracker.ietf.org/doc/html/rfc7292)

## SPKI : Simple public key infrastructure

- [SPKI/SDSI Certificates](https://theworld.com/~cme/html/spki.html)



# cipher suit

## server https cipher suite
see [nmap.md](nmap.md) # SSL server cipher suite

## curl https cipher suites
see [curl.md](curl.md) # client ssl cipher suites

## java client 1
- [Missing ECDHE Ciphers in 8-jdk-alpine #3002](https://github.com/adoptium/temurin-build/issues/3002)

```bash
# 远程下载 Ciphers.java
curl -fsSL https://confluence.atlassian.com/stashkb/files/679609085/679772359/2/1648624258064/Ciphers.java -o Ciphers.java

# 或者直接本地新增一个
cat > Ciphers.java <<EOF
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import javax.net.ssl.SSLServerSocketFactory;

public class Ciphers {
    public static void main(String[] args) {
        SSLServerSocketFactory ssf = (SSLServerSocketFactory)SSLServerSocketFactory.getDefault();

        String[] defaultCiphers = ssf.getDefaultCipherSuites();
        String[] availableCiphers = ssf.getSupportedCipherSuites();

        TreeMap<String, Boolean> ciphers = new TreeMap<String, Boolean>();

        for(int i=0; i<availableCiphers.length; ++i )
            ciphers.put(availableCiphers[i], Boolean.FALSE);

        for(int i=0; i<defaultCiphers.length; ++i )
            ciphers.put(defaultCiphers[i], Boolean.TRUE);

        System.out.println("Default\tCipher");
        for(Iterator i = ciphers.entrySet().iterator(); i.hasNext(); ) {
            Map.Entry cipher=(Map.Entry)i.next();

            if(Boolean.TRUE.equals(cipher.getValue()))
                System.out.print('*');
            else
                System.out.print(' ');

            System.out.print('\t');
            System.out.println(cipher.getKey());
        }
    }
}
EOF




docker run -it --rm \
  --entrypoint="/bin/sh" \
  -v ./Ciphers.java:/Ciphers.java \
  docker.io/library/eclipse-temurin:8-jdk-alpine \
  -c 'javac Ciphers.java ; java Ciphers'

Default	Cipher
*	TLS_AES_128_GCM_SHA256
*	TLS_AES_256_GCM_SHA384
*	TLS_DHE_DSS_WITH_AES_128_CBC_SHA
*	TLS_DHE_DSS_WITH_AES_128_CBC_SHA256
*	TLS_DHE_DSS_WITH_AES_128_GCM_SHA256
*	TLS_DHE_DSS_WITH_AES_256_CBC_SHA
*	TLS_DHE_DSS_WITH_AES_256_CBC_SHA256
*	TLS_DHE_DSS_WITH_AES_256_GCM_SHA384
*	TLS_DHE_RSA_WITH_AES_128_CBC_SHA
*	TLS_DHE_RSA_WITH_AES_128_CBC_SHA256
*	TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
*	TLS_DHE_RSA_WITH_AES_256_CBC_SHA
*	TLS_DHE_RSA_WITH_AES_256_CBC_SHA256
*	TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
*	TLS_EMPTY_RENEGOTIATION_INFO_SCSV
*	TLS_RSA_WITH_AES_128_CBC_SHA
*	TLS_RSA_WITH_AES_128_CBC_SHA256
*	TLS_RSA_WITH_AES_128_GCM_SHA256
*	TLS_RSA_WITH_AES_256_CBC_SHA
*	TLS_RSA_WITH_AES_256_CBC_SHA256
*	TLS_RSA_WITH_AES_256_GCM_SHA384


curl -fsSL https://repo1.maven.org/maven2/org/bouncycastle/bcprov-ext-jdk18on/1.76/bcprov-ext-jdk18on-1.76.jar -o bcprov-ext-jdk18on-1.76.jar
#JAVA_HOME=/opt/java/openjdk
ls -l ${JAVA_HOME}/jre/lib/ext
ls -l ${JAVA_HOME}/jre/lib/security/java.security
grep "security.provider." ${JAVA_HOME}/jre/lib/security/java.security

docker run -it --rm \
  --entrypoint="/bin/sh" \
  -v ./Ciphers.java:/Ciphers.java \
  -v ./bcprov-ext-jdk18on-1.76.jar:/opt/java/openjdk/jre/lib/ext/bcprov-ext-jdk18on-1.76.jar \
  docker.io/library/eclipse-temurin:8-jdk-alpine \
  -c '
  echo -e "\nsecurity.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> ${JAVA_HOME}/jre/lib/security/java.security ;
  javac Ciphers.java ;
  java Ciphers
  '

Default	Cipher
*	TLS_AES_128_GCM_SHA256
*	TLS_AES_256_GCM_SHA384
*	TLS_DHE_DSS_WITH_AES_128_CBC_SHA
*	TLS_DHE_DSS_WITH_AES_128_CBC_SHA256
*	TLS_DHE_DSS_WITH_AES_128_GCM_SHA256
*	TLS_DHE_DSS_WITH_AES_256_CBC_SHA
*	TLS_DHE_DSS_WITH_AES_256_CBC_SHA256
*	TLS_DHE_DSS_WITH_AES_256_GCM_SHA384
*	TLS_DHE_RSA_WITH_AES_128_CBC_SHA
*	TLS_DHE_RSA_WITH_AES_128_CBC_SHA256
*	TLS_DHE_RSA_WITH_AES_128_GCM_SHA256
*	TLS_DHE_RSA_WITH_AES_256_CBC_SHA
*	TLS_DHE_RSA_WITH_AES_256_CBC_SHA256
*	TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
*	TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
*	TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256
*	TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
*	TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
*	TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384
*	TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
*	TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
*	TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
*	TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
*	TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
*	TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
*	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
*	TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA
*	TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256
*	TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256
*	TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA
*	TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384
*	TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384
*	TLS_ECDH_RSA_WITH_AES_128_CBC_SHA
*	TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256
*	TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256
*	TLS_ECDH_RSA_WITH_AES_256_CBC_SHA
*	TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384
*	TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384
*	TLS_EMPTY_RENEGOTIATION_INFO_SCSV
*	TLS_RSA_WITH_AES_128_CBC_SHA
*	TLS_RSA_WITH_AES_128_CBC_SHA256
*	TLS_RSA_WITH_AES_128_GCM_SHA256
*	TLS_RSA_WITH_AES_256_CBC_SHA
*	TLS_RSA_WITH_AES_256_CBC_SHA256
*	TLS_RSA_WITH_AES_256_GCM_SHA384
```
## java client 2

```pom
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.17</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.example</groupId>
    <artifactId>demo</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>demo</name>
    <description>Demo project for Spring Boot</description>
    <properties>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>com.aliyun</groupId>
            <artifactId>aliyun-java-sdk-ram</artifactId>
            <version>3.0.0</version>
        </dependency>
        <dependency>
            <groupId>com.aliyun</groupId>
            <artifactId>aliyun-java-sdk-ecs</artifactId>
            <version>4.2.0</version>
        </dependency>
        <dependency>
            <groupId>com.aliyun</groupId>
            <artifactId>aliyun-java-sdk-core</artifactId>
            <version>4.5.0</version>
        </dependency>
        <dependency>
            <groupId>com.alibaba.fastjson2</groupId>
            <artifactId>fastjson2</artifactId>
            <version>2.0.41</version>
        </dependency>
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>2.15.0</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>

```

test java
```java
        public void checkClientCipherSuits() {
            try {
                IHttpClient client = HttpClientFactory.buildClient(DefaultProfile.getProfile());
                System.out.println("====== test2 IHttpClient : " + client.getClass());
                ApacheHttpClient ap = (ApacheHttpClient) client;
                //ApacheHttpClient ap = ApacheHttpClient.getInstance();

                Field field = ApacheHttpClient.class.getDeclaredField("httpClient");
                field.setAccessible(true);
                CloseableHttpClient httpClient = (CloseableHttpClient) ReflectionUtils.getField(field, ap);
                String url = "https://www.howsmyssl.com/a/check";
                HttpUriRequest request = RequestBuilder.create("GET")
                        .setUri(url)
                        .build();
                CloseableHttpResponse response = httpClient.execute(request);
                String str = IOUtils.toString(response.getEntity().getContent(), StandardCharsets.UTF_8);
                System.out.println("====== test2 success :" + str);
            } catch (Exception e) {
                System.err.println("====== test2 failed.");
                e.printStackTrace();
            }
        }
```

output on macos
```
{"given_cipher_suites":["TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384","TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384","TLS_RSA_WITH_AES_256_CBC_SHA256","TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384","TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384","TLS_DHE_RSA_WITH_AES_256_CBC_SHA256","TLS_DHE_DSS_WITH_AES_256_CBC_SHA256","TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA","TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA","TLS_RSA_WITH_AES_256_CBC_SHA","TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA","TLS_ECDH_RSA_WITH_AES_256_CBC_SHA","TLS_DHE_RSA_WITH_AES_256_CBC_SHA","TLS_DHE_DSS_WITH_AES_256_CBC_SHA","TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256","TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256","TLS_RSA_WITH_AES_128_CBC_SHA256","TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256","TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256","TLS_DHE_RSA_WITH_AES_128_CBC_SHA256","TLS_DHE_DSS_WITH_AES_128_CBC_SHA256","TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA","TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA","TLS_RSA_WITH_AES_128_CBC_SHA","TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA","TLS_ECDH_RSA_WITH_AES_128_CBC_SHA","TLS_DHE_RSA_WITH_AES_128_CBC_SHA","TLS_DHE_DSS_WITH_AES_128_CBC_SHA","TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384","TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256","TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384","TLS_RSA_WITH_AES_256_GCM_SHA384","TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384","TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384","TLS_DHE_RSA_WITH_AES_256_GCM_SHA384","TLS_DHE_DSS_WITH_AES_256_GCM_SHA384","TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256","TLS_RSA_WITH_AES_128_GCM_SHA256","TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256","TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256","TLS_DHE_RSA_WITH_AES_128_GCM_SHA256","TLS_DHE_DSS_WITH_AES_128_GCM_SHA256","TLS_EMPTY_RENEGOTIATION_INFO_SCSV"],"ephemeral_keys_supported":true,"session_ticket_supported":false,"tls_compression_supported":false,"unknown_cipher_suite_supported":false,"beast_vuln":false,"able_to_detect_n_minus_one_splitting":false,"insecure_cipher_suites":{},"tls_version":"TLS 1.2","rating":"Probably Okay"}
```



```bash
docker run -it --rm \
  --entrypoint="/bin/sh" \
  -p 5005:5005 \
  -v ./target/demo-0.0.1-SNAPSHOT.jar:/demo-0.0.1-SNAPSHOT.jar \
  docker.io/library/eclipse-temurin:8-jdk-alpine \
  -c 'java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005 -jar /demo-0.0.1-SNAPSHOT.jar'
```

output on alpine container
```plain
{"given_cipher_suites":["TLS_AES_256_GCM_SHA384","TLS_AES_128_GCM_SHA256","TLS_DHE_RSA_WITH_AES_256_GCM_SHA384","TLS_DHE_DSS_WITH_AES_256_GCM_SHA384","TLS_DHE_RSA_WITH_AES_128_GCM_SHA256","TLS_DHE_DSS_WITH_AES_128_GCM_SHA256","TLS_DHE_RSA_WITH_AES_256_CBC_SHA256","TLS_DHE_DSS_WITH_AES_256_CBC_SHA256","TLS_DHE_RSA_WITH_AES_128_CBC_SHA256","TLS_DHE_DSS_WITH_AES_128_CBC_SHA256","TLS_DHE_RSA_WITH_AES_256_CBC_SHA","TLS_DHE_DSS_WITH_AES_256_CBC_SHA","TLS_DHE_RSA_WITH_AES_128_CBC_SHA","TLS_DHE_DSS_WITH_AES_128_CBC_SHA","TLS_RSA_WITH_AES_256_GCM_SHA384","TLS_RSA_WITH_AES_128_GCM_SHA256","TLS_RSA_WITH_AES_256_CBC_SHA256","TLS_RSA_WITH_AES_128_CBC_SHA256","TLS_RSA_WITH_AES_256_CBC_SHA","TLS_RSA_WITH_AES_128_CBC_SHA","TLS_EMPTY_RENEGOTIATION_INFO_SCSV"],"ephemeral_keys_supported":true,"session_ticket_supported":false,"tls_compression_supported":false,"unknown_cipher_suite_supported":false,"beast_vuln":false,"able_to_detect_n_minus_one_splitting":false,"insecure_cipher_suites":{},"tls_version":"TLS 1.3","rating":"Probably Okay"}
```


