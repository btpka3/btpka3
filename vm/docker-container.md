
## 说明

docker 在最初的时候，都是 `docker rmi`, `docker rm` 等命令操作 image、container 的。
这些命令都混合在一起，比较混乱。现在是把 container 相关的命令都放到 `docker container *` 下面了


## 参考

- [docker container](https://docs.docker.com/engine/reference/commandline/container/)



## 常用命令

```bash
docker container attach	    # Attach local standard input, output, and error streams to a running container
docker container commit	    # Create a new image from a container’s changes
docker container cp	        # Copy files/folders between a container and the local filesystem
docker container create	    # Create a new container
docker container diff	    # Inspect changes to files or directories on a container’s filesystem
docker container exec	    # Run a command in a running container
docker container export	    # Export a container’s filesystem as a tar archive
docker container inspect	# Display detailed information on one or more containers
docker container kill	    # Kill one or more running containers
docker container logs	    # Fetch the logs of a container
docker container ls	        # List containers
docker container pause	    # Pause all processes within one or more containers
docker container port	    # List port mappings or a specific mapping for the container
docker container prune	    # Remove all stopped containers
docker container rename	    # Rename a container
docker container restart	# Restart one or more containers
docker container rm	        # Remove one or more containers
docker container run	    # Run a command in a new container
docker container start	    # Start one or more stopped containers
docker container stats	    # Display a live stream of container(s) resource usage statistics
docker container stop	    # Stop one or more running containers
docker container top	    # Display the running processes of a container
docker container unpause	# Unpause all processes within one or more containers
docker container update	    # Update configuration of one or more containers
docker container wait       # 
```




## 示例

### env.sh

```bash
#!/bin/bash

export APP=sonarqube
# 容器的名称
export APP_C=my-${APP}
export DOCKER_REG=registry.cn-hangzhou.aliyuncs.com

export DIR_STORE="/data0/store/soft/$APP"
export DIR_STORE_DATA="${DIR_STORE}/data"

export DIR_CONF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


#
# 向控制台输出内容。消息前会追加时间戳。
#
# @param $1 要打印的消息
#
log(){
    #Cyan
    Color_ON='\033[0;36m'
    Color_Off='\033[0m'
    echo -e "${Color_ON}$(date +%Y-%m-%d.%H:%M:%S) : $1${Color_Off}" 1>&2
}
```
### setup.sh

```bash
#!/bin/bash


CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "${CUR_DIR}/env.sh"

mkdir -p "${DIR_STORE}"
mkdir -p "${DIR_STORE_DATA}"

docker stop ${APP_C}
docker rm ${APP_C}

docker create                                       \
    --name ${APP_C}                                 \
    --restart unless-stopped                        \
    -p 9000:9000                                    \
    -p 9092:9092                                    \
    -e SONARQUBE_JDBC_USERNAME=sonar                \
    -e SONARQUBE_JDBC_PASSWORD=sonar                \
    -e SONARQUBE_JDBC_URL=jdbc:postgresql://192.168.0.41/sonar \
    -v ${DIR_STORE_DATA}:/opt/sonarqube/data:rw     \
    -v ${DIR_CONF}:${DIR_CONF}                      \
    sonarqube:lts-alpine

docker start ${APP_C}

docker exec -it ${APP_C}                            \
    /data0/conf/soft/sonarqube/dev.tpl/docker/setup.sh

```
