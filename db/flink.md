
[flink](https://flink.apache.org/)


docker

```bash

docker run -d \
        --name my-flink \
        flink:1.9.0 \
        jobmanager
``` 


docker-compose.yaml 

```yaml
version: "2.1"
services:
  jobmanager:
    image: ${FLINK_DOCKER_IMAGE_NAME:-flink:1.9.0}
    expose:
      - "6123"
    ports:
      - "8081:8081"
    command: jobmanager
    environment:
      - JOB_MANAGER_RPC_ADDRESS=jobmanager

  taskmanager:
    image: ${FLINK_DOCKER_IMAGE_NAME:-flink:1.9.0}
    expose:
      - "6121"
      - "6122"
    depends_on:
      - jobmanager
    command: taskmanager
    links:
      - "jobmanager:jobmanager"
    environment:
      - JOB_MANAGER_RPC_ADDRESS=jobmanager
```

启动

```bash
docker-compose up

# 浏览器访问web 控制台
# http://localhost:8081/#/overview
```

