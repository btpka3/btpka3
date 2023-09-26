
# ORAS: OCI Registry As Storage

- [ORAS](https://oras.land/)
    - [helm](https://v3.helm.sh/docs/topics/registries/) : 实现该协议的客户端之一
        - [microbean/microbean-helm](https://github.com/microbean/microbean-helm) ： helm 的 java client
- [OCI artifacts on Docker Hub](https://docs.docker.com/docker-hub/oci-artifacts/)
- bitnami
    - docker hub : [bitnami/oras](https://hub.docker.com/r/bitnami/oras)
    - [Dockerfile](https://github.com/bitnami/containers/blob/main/bitnami/oras/1/scratch/Dockerfile)

```shell
# MacOS
brew install oras

# FCOS
rpm-ostree install golang-oras

# docker
docker run --rm docker.io/bitnami/oras version   

export DOCKER_USERNAME="E-dangqian.zll-158230@alibaba-mtee"
export DOCKER_PASSWD="xxx"
export DOCKER_REGISTRY="chengdun-sec-scr-registry.cn-hangzhou.cr.aliyuncs.com"

oras pull --registry-config docker_config.json  chengdun-sec-scr-registry.cn-hangzhou.cr.aliyuncs.com/sec/hello-artifact:v1 -o .


# 命令行设置密码（不推荐）
docker run --rm \
    -v .:/data \
    docker.io/bitnami/oras \
        pull \
        --username ${DOCKER_USERNAME} \
        --password "${DOCKER_PASSWD}" \
        chengdun-sec-scr-registry.cn-hangzhou.cr.aliyuncs.com/sec/hello-artifact:v1 \
        -o /data


# 使用配置文件存储密码
cat > docker_config.json <<EOF
{
  "auths": {
    "chengdun-sec-scr-registry.cn-hangzhou.cr.aliyuncs.com": {
      "auth": "$(echo -n "${DOCKER_USERNAME}:${DOCKER_PASSWD}" | base64)"    
    }
  }
}
EOF

docker run --rm \
    -v .:/data \
    docker.io/bitnami/oras \
        pull \
        --registry-config /data/docker_config.json \
        -o /data \
        chengdun-sec-scr-registry.cn-hangzhou.cr.aliyuncs.com/sec/hello-artifact:v1
```

# alpine

```shell
docker run -it --rm  docker.io/library/alpine:3.18 bash -l
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/"     >> /etc/apk/repositories
apk add oras-cli
oras login --username=E-dangqian.zll-158230@alibaba-mtee chengdun-sec-scr-registry.cn-hangzhou.cr.aliyuncs.com
cat ~/.docker/config.json
```

~/.docker/config.json 示例内容：

```json
{
  "auths": {
    "chengdun-sec-scr-registry.cn-hangzhou.cr.aliyuncs.com": {
      "auth": "..."    // 这个的格式是  echo -n "${DOCKER_USERNAME}:${DOCKER_PASSWD}" | base64
    }
  }
}
```