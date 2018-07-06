
```bash
curl --verbose --header 'Host: www.example.com' 'http://10.1.1.36:8000/the_url_to_test'
curl --verbose -X POST --header "Cookie: JSESSIONID=136zm5iif8o2e8tcelqk9nd6e"  http://www.lizi.com:30010/j_spring_security_logout

# 使用socks代理
ssh sshUser@sshHost -C -f -N -g -D [localBindIp:]localBindPort
curl --socks5 localhost:9999 https://www.baidu.com/

export http_proxy=http://prod11.kingsilk.net:81/
export https_proxy=http://prod11.kingsilk.net:81/
curl -v https://www.baidu.com/


export http_proxy=http://localhost:81/
curl -v https://www.baidu.com/

export https_proxy=https://localhost:1443/
export https_proxy=socks://192.168.0.12:19999
curl -v https://www.baidu.com/


# echo server
socat -v tcp-l:1234,fork exec:'/bin/echo'


# 只显示 http 头
curl -s -D - www.baidu.com -o /dev/null

# 以 GET 请求 配合 -d 处理URL参数 
curl -v -X GET -G \
    --data-urlencode a=aa中 \
    -d b=bb国 \
    "https://www.baidu.com/?x=xx#/yyy?c=cc"
    
# http basic 认证
curl -v -u username:password https://www.baidu.com/

# 查看post请求中body的数据 : --trace-ascii /dev/stdout
# 以 multipart/form-data 形式post提交数据
curl https://www.baidu.com \
    -F k1=v1 \
    -F k2=v2 \
    --trace-ascii /dev/stdout 

# 以 application/x-www-form-urlencoded 形式post提交数据
curl https://www.baidu.com \
    -d k1=v1 \
    --data-urlencode k2='v 2' \
    --trace-ascii /dev/stdout 

# 以 application/x-www-form-urlencoded 形式post提交url encode 的json数据
curl https://www.baidu.com \
    --data-urlencode param="`cat add.json`" \
    --trace-ascii /dev/stdout 


    
# POST JSON
curl -X POST \
    -H "Content-Type: application/json" \
    -d '{"username":"xyz","password":"xyz"}' \
    http://localhost:3000/api/login

# POST XML
curl -X POST \
    -H "Content-Type: application/xml" \
    -d '<run><log encoding="hexBinary">4142430A</log><result>0</result><duration>2000</duration></run>' \
    http://user:pass@myhost/hudson/job/_jobName_/postBuildResult

    
# 下载 *.tag.gz 并解压
TAG=v0.1.15
curl -fSL https://github.com/vozlt/nginx-module-vts/archive/${TAG}.tar.gz | tar -zx


# 最简单的一个 ECHO 服务器
ncat -l 2000 -k -c 'xargs -n1 echo'
```
