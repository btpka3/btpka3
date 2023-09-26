

- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
   对服务反向代理配置的一个抽象，相当与一个 nginx 的配置片断的抽象。
- [Ingress 控制器](https://kubernetes.io/zh-cn/docs/concepts/services-networking/ingress-controllers/)
   相当与 nginx 软件服务，监听 k8s 集群内的 ingress 的配置，并将其动态应用到底层的 反向代理服务上（nginx, istio等）
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx/blob/main/README.md#readme)
    - ingress-nginx : [Installation Guide](https://kubernetes.github.io/ingress-nginx/deploy/)
- [envoy](https://www.envoyproxy.io/) : 代理服务器
- [istio](https://istio.io/latest/zh/docs/setup/getting-started/) 
    - [Kubernetes Ingress](https://istio.io/latest/zh/docs/tasks/traffic-management/ingress/kubernetes-ingress/)
    - [使用 Helm 安装](https://istio.io/latest/zh/docs/setup/install/helm/)
    - [Failed for volume "istio-token" error](https://github.com/kubeflow/manifests/issues/1911)
- [Higress](https://higress.io/zh-cn/docs/overview/what-is-higress)





# istio

使用 Helm 安装

```shell
helm repo list
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# 为 Istio 组件，创建命名空间 istio-system:
kubectl create namespace istio-system
# 安装 Istio base chart，它包含了集群范围的自定义资源定义 (CRD)，这些资源必须在部署 Istio 控制平面之前安装：
helm install istio-base istio/base -n istio-system
# 使用 helm ls 命令验证 CRD 的安装情况：
helm ls -n istio-system

# 安装 Istio discovery chart，它用于部署 istiod 服务：
helm install istiod istio/istiod -n istio-system --wait
# 如果有异常，则以debug模式尝试，并同时查看对应的pod的详情
helm delete istiod -n istio-system
helm install istiod istio/istiod -n istio-system --wait --debug
kubectl get pod -n istio-system 
kubectl describe pods istiod-65fb6f64c5-dggqf -n istio-system 


# 验证 Istio discovery chart 的安装情况：
helm ls -n istio-system
# 获取已安装的 Helm Chart 的状态以确保它已部署:
helm status istiod -n istio-system
# 获取已安装的 Helm Chart 的状态以确保它已部署:
helm status istiod -n istio-system
# 检查 istiod 服务是否安装成功，其 Pod 是否正在运行:
kubectl get deployments -n istio-system --output wide
# （可选）安装 Istio 的入站网关：
kubectl create namespace istio-ingress
helm install istio-ingress istio/gateway -n istio-ingress --wait
```

本地安装

```shell
brew install istioctl
```


# ingress-nginx

