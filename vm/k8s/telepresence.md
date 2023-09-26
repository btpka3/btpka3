- [Telepresence](https://github.com/telepresenceio/telepresence)
- [install](https://github.com/telepresenceio/telepresence.io/blob/master/docs/pre-release/install/index.md)  

```shell
# intel MAC
brew install datawire/blackbird/telepresence

# 一次性安装
telepresence helm install

# 如果报错，则尝试先 uninstall 再 install
# helm uninstall traffic-manager -n ambassador

telepresence connect

curl -ik https://kubernetes.default

NACOS_ADDR=http://nacos.default.svc.cluster.local:8848
namespaceId=public
dataId=gong9.mw.tddl.conf
group=gong9-mw
curl -v -X GET "${NACOS_ADDR}/v2/cs/config?dataId=${dataId}&group=${group}&namespaceId=${namespaceId}"



# shell completion
telepresence completion -h 
telepresence completion zsh
```