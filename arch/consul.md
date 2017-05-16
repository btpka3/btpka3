
[consul](https://github.com/hashicorp/consul)



```bash
brew install consul

consul agent -dev -node mac -ui
# 浏览器访问 http://localhost:8500/ui
consul members

curl localhost:8500/v1/catalog/nodes
```