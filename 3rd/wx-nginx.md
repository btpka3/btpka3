
## 现状
1. 有静态公网IP服务器（阿里云主机），其端口80可以访问
2. 开发人员均在 ADSL 拨号上网的局域网中，网管动态获取公网IP。该动态公网IP的 80，8080 等常见端口被屏蔽，互联网上其他客户端无法直接访问。
3. 拥有域名 kingsilk.xyz

## 问题
微信的服务器认证只接受 80 端口的服务器URL。其[沙盒测试](http://mp.weixin.qq.com/debug/cgi-bin/sandboxinfo?action=showinfo&t=sandbox/index) 环境也是如此。

## 思路
1. 在开发环境局域网的路由器上分派固定端口映射：比如：动态公网IP地址上的 16030 直接映射到 你的开发机 192.168.0.60 的 16030 端口
2. 注册花生壳，并开发环境局域网的路由器进行配置、启用。使得花生壳默认提供的免费域名 （比如：`kingsilk.imwork.net` 始终为动态公网IP地址）
3. 在域名服务商的平台上（阿里云），进行泛域名配置。比如新增 CNAME（别名） `*.ddns.kingsilk.xyz` 指向到 阿里云主机的静态公网IP
4. 在 阿里云主机 上配置 nginx 进行反向代理，将 `p${port}.ddns.kingsilk.xyz` 的请求都转发到 `http://kingsilk.imwork.net:${port}` 上：

    ```nginx
    # 该配置主要是为了方便开发人员自测微信相关API

    server {
        listen *:80;
        server_name *.ddns.kingsilk.xyz;
        root /404;

        client_max_body_size 20m;
        ignore_invalid_headers off;

        access_log  logs/ddns.kingsilk.xyz.access.log;
        error_log   logs/ddns.kingsilk.xyz.error.log;

        location ~ /qh/mall/local/ {
            set $p 9999;
            if ($host ~ "p(\d*)\.ddns\.kingsilk\.xyz" ) {
                set $p $1;
            }
            proxy_pass              http://kingsilk.imwork.net:$p;
            proxy_set_header        Host            $host;   # ???  $http_host;
            proxy_set_header        X-Real-IP       $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
        }
    }
    ```

5. 在你的主机上启动 你的服务，确保 `http://localhost:16030` 访问没问题
6. 测试 `http://kingsilk.imwork.net:16030` 访问没有问题
7. 测试 `http://p16030.ddns.kingsilk.xyz` 访问没有问题
8. 在你的开发机上按照微信的 [接入指南](http://mp.weixin.qq.com/wiki/17/2d4265491f12608cd170a95559800f2d.html) ，
设置自定义的 token 并编写服务器真实性验证 api。这里验证的URL是  `http://localhost:16030/testZll/verifyServer` （TestZllController.groovy）:

    ```groovy
    package xyz.kingsilk.qh.wap.controller

    import org.apache.commons.codec.binary.Hex
    import org.apache.commons.codec.digest.DigestUtils

    class TestZllController {

        def index() {
            render "OK " + System.currentTimeMillis()
        }

        def appID = "xxxxx"
        def appsecret = "xxxxxxxx"
        def token = "yyyyy"

        def verifyServer() {
            log.debug("收到微信服务器验证请求")

            def signature = params.signature
            def timestamp = params.timestamp
            def nonce = params.nonce
            def echostr = params.echostr

            def arr = [token, timestamp, nonce]
            arr.sort()
            def sign = Hex.encodeHexString(DigestUtils.sha(arr.join()))
            println sign
            render(sign == signature ? echostr : "invalid signature")
        }

    }
    ```

8. 在微信的沙盒测试上提交测试服务器的URL和token，完成服务器的接入验证。按照上面的示例：

    ```
    URL   = http://p16030.ddns.kingsilk.xyz/testZll/verifyServer
    token = yyyyy
    ```
