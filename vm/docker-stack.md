

## 说明

docker stack 是一组服务的组合，跟 docker-compose 使用的配置文件比较类似。
方便使用 compose 文件管理和发布应用。

## 参考

- [docker stack](https://docs.docker.com/engine/reference/commandline/stack/)
- [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)

## docker stack

```bash
docker stack ls
        # 列出目前有的 stack 列表

docker stack deploy --compose-file xxx  yourStackName 
        # 部署一个 stack

docker stack ps yourStackName
        # 列出 stack 中的任务                       

docker stack rm yourStackName    
        # 删除一个 stack

docker stack service yourStackName
```


# docker stack

docker stack 是方便使用 compose 文件管理和发布应用的一个子命令。

```bash
docker stack deploy --compose-file docker-swarm-sample-compose.yml my-stack
docker stack ls
docker stack ps my-stack
docker stack services my-stack

```
