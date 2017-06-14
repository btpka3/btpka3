
# 简介

[traefik](https://github.com/containous/traefik) 是一个现代的 Http 反向代理服务器，也是负载均衡器。


## 安装

```
mkdir -p ~/tmp/my-traefik/
cd ~/tmp/my-traefik/

# 下载一个示例配置文件
wget -O traefik.toml https://raw.githubusercontent.com/containous/traefik/master/traefik.sample.toml

# 下载并安装镜像
docker run -d \
    --name my-traefik \
    -p 8080:8080 \
    -p 80:80 \
    -v $PWD/traefik.toml:/etc/traefik/traefik.toml \
    traefik
```


## 参考
* [quick start](https://docs.traefik.io/#quickstart)

