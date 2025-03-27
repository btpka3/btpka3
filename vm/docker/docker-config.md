

配置文件最终也是以 文件的方式 mount 到容器内的，那与 data volume 的差别是？ 
—— 被 swarm manager 加密保存。

## 参考

- [docker config](https://docs.docker.com/engine/reference/commandline/config/)
- [Store configuration data using Docker Configs](https://docs.docker.com/engine/swarm/configs/)

## 示例


```bash
docker config create	# Create a config from a file or STDIN
docker config inspect	# Display detailed information on one or more configs
docker config ls	    # List configs
docker config rm	    # Remove one or more configs
```



## hello world

```bash
# 创建一个配置
echo "This is a config" | docker config create my-config -

# 使用该配置来启动一个服务
docker service create --name redis --config my-config redis:alpine
# --config src=homepage,target="\inetpub\wwwroot\index.html" 


docker ps --filter name=redis -q
docker container exec $(docker ps --filter name=redis -q) ls -l /my-config
docker container exec $(docker ps --filter name=redis -q) cat /my-config

# 将一个服务移除 my-config 的依赖
docker service update --config-rm my-config redis
docker service rm redis
docker config rm my-config
```
