- helm : [install](https://helm.sh/zh/docs/intro/install/)

- [charts](https://helm.sh/zh/docs/topics/charts/)

```shell
# MacOs 安装
brew install helm
# Fedora 安装
dnf install helm


helm version

helm repo add xxxReponName https://xx.repo.com
helm repo update
helm pull longhorn/longhorn --version v1.4.0
tar xf longhorn-1.4.0.tgz 
cd longhorn/

helm install longhorn -n longhorn 
helm list -A
```
