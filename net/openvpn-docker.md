


# setup


## server
```bash
OVPN_DATA_DIR=/data0/store/soft/openvpn-server/ovpn-data-uf-aliyun
OVPN_DATA_CLIENT_DIR=${OVPN_DATA_DIR}/client

mkdir -p $OVPN_DATA_DIR
mkdir -p $OVPN_DATA_CLIENT_DIR

# 初始化，在数据目录中创建配置文件
docker run \
    -v $OVPN_DATA_DIR:/etc/openvpn \
    --log-driver=none \
    --rm \
    kylemanna/openvpn:2.4 \
    ovpn_genconfig \
    -u udp://30.6.248.61

# 初始化，在数据目录中创建证书
docker run \
    -v $OVPN_DATA_DIR:/etc/openvpn \
    --log-driver=none \
    --rm \
    -it \
    kylemanna/openvpn:2.4 \
    ovpn_initpki


# 启动 OpenVpn 服务器
docker create                                       \
    --name my-openvpn-server                        \
    --restart unless-stopped                        \
    -p 1194:1194/udp                                \
    -v $OVPN_DATA_DIR:/etc/openvpn                  \
    --cap-add=NET_ADMIN                             \
    kylemanna/openvpn:2.4

docker start my-openvpn-server

# 检查: 查看 启动状态
docker ps 

# 检查: 查看 启动日志
docker logs my-openvpn-server 

# 检查 监听情况
lsof -n -i :1194

# 创建一个没有密码的 客户端证书
docker run -v $OVPN_DATA:/etc/openvpn \
    -v $OVPN_DATA_DIR:/etc/openvpn \
    --rm \
    -it \
    kylemanna/openvpn:2.4 \
    easyrsa \
        build-client-full \
        TEST_USER \
        nopass

# 导出客户端证书
docker run \
    -v $OVPN_DATA_DIR:/etc/openvpn \
    --log-driver=none \
    --rm \
    -it \
    kylemanna/openvpn:2.4 \
    ovpn_getclient TEST_USER \
    > ${OVPN_DATA_CLIENT_DIR}/TEST_USER.ovpn
```

## client

```bash
OVPN_DATA_DIR=/data0/store/soft/openvpn-server/ovpn-data-uf-aliyun
OVPN_DATA_CLIENT_DIR=${OVPN_DATA_DIR}/client


docker run -it --cap-add=NET_ADMIN -v $OVPN_DATA_DIR:/etc/openvpn kylemanna/openvpn:2.4 sh

# 创建 docker 容器并启动
docker create                                       \
    --name my-openvpn-client                        \
    -v $OVPN_DATA_DIR:/etc/openvpn                  \
    --cap-add=NET_ADMIN                             \
    kylemanna/openvpn:2.4                           \
    openvpn                                         \
        --config /etc/openvpn/client/TEST_USER.ovpn

docker start my-openvpn-client


# 
docker run \
    -v $OVPN_DATA_DIR:/etc/openvpn \
    --log-driver=none \
    --rm \
    -it \
    kylemanna/openvpn:2.4 \
    openvpn \
        --config /etc/openvpn/client/dangqian.ovpn

```

# 参考
- docker image : [kylemanna/openvpn](https://hub.docker.com/r/kylemanna/openvpn/)
