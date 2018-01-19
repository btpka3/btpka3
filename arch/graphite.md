 

## 安装

```bash
docker run -d \
  --name my-graphite \
  -p 8080:80 \
  -p 2003:2003 \
  sitespeedio/graphite
  
docker cp my-graphite:/opt/graphite/conf/storage-schemas.conf /tmp/storage-schemas.conf

# 浏览器默认访问。
# 默认用户名为 guest/guest。 对应的配置文件为 docker 容器内： /etc/nginx/.htpasswd
http://localhost:8080/

yum install nc
while true; do echo "foo.bar  $(( $RANDOM % 100 )) `date +%s`" | nc 192.168.0.41 2003 ; sleep 1 ; done
while true; do echo "test.bash.stats $(( $RANDOM % 100 )) `date +%s`" | nc 192.168.0.41 2003 ; sleep 1 ; done

while true; do echo "test.bash.stats $(( $RANDOM % 100 )) `date +%s`" ;sleep 1 ;  done


```

## 参考 

* [functions](http://graphite.readthedocs.io/en/latest/functions.html)
* [The Render URL API](http://graphite.readthedocs.io/en/latest/render_api.html)


## statsd

[statsd](https://github.com/etsy/statsd) 是一个简单 NodeJs 程序监听数据，并转发给 graphite


## tessera

[tessera](https://github.com/tessera-metrics/tessera) 是 graphite 的 web 前端画面，比 graphite 自带的漂亮。


```bash
# 192.168.0.41 是我自己的 docker 运行 graphite 的主机地址。
docker run \
    -itd \
    --name my-tessera \
    -p 8081:80 \
    -e GRAPHITE_URL=http://192.168.0.41:8080 \
    aalpern/tessera-simple
```

