- helm : [install](https://helm.sh/zh/docs/intro/install/)

- [charts](https://helm.sh/zh/docs/topics/charts/)

helm 处理的模板文件只支持 yaml/json, 不支持其他类型的文件，比如 html/纯文本 等

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


# chart

```shell
helm create mychart
# for 第一个demo，删除所有默认模板
rm -rf mychart/templates/*

# 创建第一个静态的configMap 模板
cat > mychart/templates/configmap.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: mychart-configmap
data:
  myvalue: "Hello World"
EOF

# 安装， 默认会安装到 namespace=default 下面
helm install --help
helm install full-coral ./mychart
# 检查
helm get manifest full-coral

# 检查
kubectl -n default get ConfigMap mychart-configmap
# 查看 configMap 的内容
kubectl -n default describe ConfigMap mychart-configmap
# 运行态直接编辑configMap
kubectl -n default edit configmap mychart-configmap

# 使用模板变量
cat > mychart/templates/configmap.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
data:
  myvalue: "Hello World"
EOF

helm install clunky-serval ./mychart
# 此时输出的内容中 configMap 的 name = clunky-serval-configmap
helm get manifest clunky-serval


# 如果仅仅想看看生成结果，而不实际进行安装，则可以使用 --dry-run  参数
# 如果要覆盖单个 value 值，可以使用 `--set`
# 如果要覆盖多个 value 值，可以使用 `--values` 来提供一个 yaml 文件
helm install geared-marsupi ./mychart --dry-run --debug --set favoriteDrink=slurm
helm install geared-marsupi ./mychart --dry-run --debug --values xxx.yaml

# 本地渲染模板Only
helm template . --show-only templates/configmap.yaml --values xxx.yaml
```
