
[MariaDB](https://mariadb.org/)


## docker 安装

```
docker run --name some-mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:tag



mkdir -p /Users/zll/tmp/my-mariadb/db
mkdir -p /Users/zll/tmp/my-mariadb/configdb
touch /Users/zll/tmp/my-mongo/mongod.conf


docker pull mongo:3.2.10
docker run -d \
    --name my-mongo \
    -p 27017:27017 \
    -v /Users/zll/tmp/my-mongo/mongod.conf:/etc/mongod.conf \
    -v /Users/zll/tmp/my-mongo/db:/data/db \
    -v /Users/zll/tmp/my-mongo/configdb:/data/configdb \
    mongo:3.2.10

docker exec -it my-mongo bash
```
