
```
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


# 只显示 http 头
curl -s -D - www.baidu.com -o /dev/null

# 查看post请求中body的数据 : --trace-ascii /dev/stdout
# 以 multipart/form-data 形式post提交数据
curl https://www.baidu.com \
    -F k1=v1 \
    -F k2=v2 \
    --trace-ascii /dev/stdout 
# 以 application/x-www-form-urlencoded 形式post提交数据
curl https://www.baidu.com \
    -d k1=v1 \
    -d k2=v2 \
    --trace-ascii /dev/stdout 
```
