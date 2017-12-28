

# 简介

[Zipkin](https://zipkin.io/pages/quickstart.html) 是一个分布式的追踪系统。
可以用以跟踪一个请求在多个分布式应用之间的调用过程，以便分析性能瓶颈、进行结构优化。

# 使用 docker 尝试

```bash

mkdir -p /tmp/my-zipkin
mkdir -p /tmp/my-zipkin/prometheus
cd /tmp/my-zipkin
wget https://raw.githubusercontent.com/openzipkin/docker-zipkin/release-2.4.0/docker-compose.yml
wget -P prometheus https://raw.githubusercontent.com/openzipkin/docker-zipkin/release-2.4.0/prometheus/create-datasource-and-dashboard.sh
wget -P prometheus https://raw.githubusercontent.com/openzipkin/docker-zipkin/release-2.4.0/prometheus/prometheus.yml
docker-compose up
#docker-compose down

# 浏览器访问 http://localhost:9411/zipkin/


# docker 独立运行
docker run -d -p 9411:9411 openzipkin/zipkin
```
