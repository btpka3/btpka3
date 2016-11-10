
```
curl --verbose --header 'Host: www.example.com' 'http://10.1.1.36:8000/the_url_to_test'
curl --verbose -X POST --header "Cookie: JSESSIONID=136zm5iif8o2e8tcelqk9nd6e"  http://www.lizi.com:30010/j_spring_security_logout
```

# 只显示 http 头

```
curl -s -D - www.baidu.com -o /dev/null
```

# 使用socks代理

```
ssh sshUser@sshHost -C -f -N -g -D [localBindIp:]localBindPort     
curl --socks5 localhost:9999 https://www.baidu.com/
```