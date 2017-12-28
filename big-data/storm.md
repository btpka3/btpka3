

# 参考

- [storm](http://storm.apache.org/releases/1.1.1/Configuration.html)
- [storm@docker](https://hub.docker.com/_/storm/)
- [storm@gtihub](https://github.com/apache/storm/)


# test

```bash
docker run -d -\
    -restart always \
    --name some-zookeeper 
    zookeeper:3.4.10

docker run -d \
    --restart always \
    --name some-nimbus \
    --link some-zookeeper:zookeeper \
    storm:1.1.1 \
    storm nimbus
    
docker run -d \
    --restart always \
    --name supervisor \
    --link some-zookeeper:zookeeper \
    --link some-nimbus:nimbus \
    storm:1.1.1 \
    storm supervisor
    
docker run \
    -it \
    --rm \ 
    -v \
    --link some-nimbus:nimbus \
    $(pwd)/topology.jar:/topology.jar \
    storm:1.1.1 \
    storm jar /topology.jar org.apache.storm.starter.WordCountTopology topology
```
