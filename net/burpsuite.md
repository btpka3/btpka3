


## intruder


打开 burpsuite ，

- `Options` 标签页：修改本地代理服务器的监听端口为 9999 
- `Proxy`, 并设置  中设置 "Intercept is on"
- 导出证书，并添加的系统根CA 以及 Firefox 的根CA 中
- 使用 CURL 模拟请求 :
     
    ```bash
    curl -v \
    -x 127.0.0.1:9999 \
    "http://uf-daily.alibaba.net/?p1=11&p2=22"
    ```
- 之后，将拦截的信息，点击 "Action" 按钮，选择 "Sent to Introder"
- 在 `Introder` 菜单 选择 Accack Type , 设置 Payloads 后，点击 `Start attack` 即可.
  默认识别出有两个变量替换，格式如下
  
    ```txt
    GET /?p1=§11§&p2=§22§ HTTP/1.1
    Host: uf-daily.alibaba.net
    User-Agent: curl/7.54.0
    Accept: */*
    Connection: close
    ``` 



### attack type

- Sniper :
    只能使用一个 payload，依次替换所有 payload Positions 。
    
    如果 payload1 为 `xx`,`yy`,`zz`
    
    则结果分别为：
    
    ```txt
    GET /?p1=11&p2=22 HTTP/1.1
    GET /?p1=xx&p2=p2val HTTP/1.1
    GET /?p1=yy&p2=p2val HTTP/1.1
    GET /?p1=zz&p2=p2val HTTP/1.1
    GET /?p1=p1val&p2=xx HTTP/1.1
    GET /?p1=p1val&p2=yy HTTP/1.1
    GET /?p1=p1val&p2=zz HTTP/1.1
    ```
- Battering ram :
    使用单个变量，同时替换所有 payload Positions
    
    如果 payload1 为 `xx`,`yy`,`zz`
    
    则结果分别为：
    
    ```txt
    GET /?p1=11&p2=22 HTTP/1.1
    GET /?p1=xx&p2=xx HTTP/1.1
    GET /?p1=yy&p2=yy HTTP/1.1
    GET /?p1=zz&p2=zz HTTP/1.1
    ```

- Pitchfork :
    有多少个payload Positions，就有多少个变量，对应位置替换对应的变量，次数为长度最短的。

    如果 payload1 为 `xx`,`yy`,`zz`
    如果 payload2 为 `aa`,`bb`
    
    ```txt
    GET /?p1=11&p2=22 HTTP/1.1
    GET /?p1=xx&p2=aa HTTP/1.1
    GET /?p1=yy&p2=bb HTTP/1.1
    ```

- Cluster bomb
   使用多个变量，笛卡尔乘积的方式。

    如果 payload1 为 `xx`,`yy`,`zz`
    如果 payload2 为 `aa`,`bb`
    
    ```txt
    GET /?p1=11&p2=22 HTTP/1.1
    GET /?p1=xx&p2=aa HTTP/1.1
    GET /?p1=yy&p2=aa HTTP/1.1
    GET /?p1=zz&p2=aa HTTP/1.1
    GET /?p1=xx&p2=bb HTTP/1.1
    GET /?p1=yy&p2=bb HTTP/1.1
    GET /?p1=zz&p2=bb HTTP/1.1
    ```
    
