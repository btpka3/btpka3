https://kustomize.io/



# 安装
```shell
brew install kustomize
```

# 示例：application.properties 外部文件


手动创建 application.properties

```properties
a=a001
b=b001
```

手动创建 kustomization.yaml

```yaml
generatorOptions:
  # 避免每次都创建新的 configMap, 而是每次都使用新的
  disableNameSuffixHash: true 
configMapGenerator:
  - name: application-config
    files:
      - application.properties
```

检验
```shell
# 生成并输出到 stdout
# 方式二：通过 kubectl 命令
kubectl kustomize .

# 方式一：直接使用本地独立安装的 kustomize 命令
kustomize build
```

部署
```shell
# 注意：使用的是 `-k` 命令
kubectl apply -k .
```