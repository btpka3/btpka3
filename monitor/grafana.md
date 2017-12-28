

# 参考


- [Download](https://grafana.com/grafana/download?platform=docker)
- [使用 Grafana、collectd 和 InfluxDB 打造现代监控系统](https://linux.cn/article-5252-1.html)




# 运行

```bash
mkdir -p /data0/store/soft/grafana/data

docker create                                           \
    --name=my-grafana                                   \
    -p 3000:3000                                        \
    -v /data0/store/soft/grafana/data:/var/lib/grafana  \
    -e "GF_SECURITY_ADMIN_PASSWORD=123456"              \
    grafana/grafana:4.6.2
 
docker start my-grafana

# 浏览器访问 http://localhost:3000 , 用户名: admin, 密码: 123456 (默认密码是 admin）
```
