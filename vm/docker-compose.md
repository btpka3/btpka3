
## Docker Compose

适用于:

* 开发环境
* 自动测试环境
* 单主机上的部署

参考

* 《[Docker Compose overview](https://docs.docker.com/compose/)》
* [Overview of docker compose CLI](https://docs.docker.com/compose/reference/)
* [Compose specification](https://docs.docker.com/compose/compose-file/)
* 《[Docker集群管理之Docker Compose](http://www.csdn.net/article/1970-01-01/2825554)》

```shell
docker compose up    # Create and start the entire stack or some of its services
docker compose down
docker compose build
docker compose pull  # pull stack images
docker compose push  # push stack images
```



docker-compose.yml

```yaml
version: '2'
services:
    web:
        build: .
        ports:
            - "5000:5000"
        volumes:
            - .:/code
        depends_on:
            - redis
    redis:
        image: redis
```
