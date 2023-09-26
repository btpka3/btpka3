[krew](https://github.com/kubernetes-sigs/krew) 是 kubectl 的插件的包管理器


```shell
#查看安装的插件列表
kubectl krew list
kubectl plugin list


# 备份安装的插件列表
kubectl krew list | tee backup.txt
# 恢复安装的插件列表
kubectl krew install < backup.txt
```
