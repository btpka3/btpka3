

## 安装

```bash
docker swarm init

# docker swarm 方式安装 openfaas
git clone https://github.com/openfaas/faas  
cd faas  
git checkout 0.8.2
./deploy_stack.sh

# MacOS 安装 faas-cli
brew install faas-cli


# 部署示例 function
faas deploy


# 浏览器访问: http://localhost:8080/

```

## 参考

- [openfaas](https://github.com/openfaas/faas)
- [doc](http://docs.openfaas.com/)
- [guide](https://github.com/openfaas/faas/tree/master/guide)
