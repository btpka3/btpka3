

# docker stack

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
