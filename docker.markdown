
《[Docker 入门实战](http://yuedu.baidu.com/ebook/d817967416fc700abb68fca1?fr=aladdin&key=docker&f=read###)》

MacOS上，image的存储位置在 `~/Library/Containers/com.docker.docker/Data/`

# Mac

## 限制
1. 没有 docker0 bridge
1. 无法ping到容器，消息也无法从容器返回到host
1. 无法做到每个容器一个IP地址
 

### 容器要访问Host主机上的服务

```
# 为 lo0 绑定多个IP地址
sudo ifconfig lo0 alias 10.200.10.1/24

# 配置容器中的服务监听上述IP地址，或者 0.0.0.0

```

### host主机要访问容器内的服务
需要配置端口转发。

```
docker run -d -p 80:80 --name webserver nginx
```

# 网络

```
# 默认有三个网络
docker network ls 
```