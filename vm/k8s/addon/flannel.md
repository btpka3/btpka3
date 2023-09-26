- kubenetes :  [安装扩展（Addon）](https://kubernetes.io/zh-cn/docs/concepts/cluster-administration/addons/)
- [flannel](https://github.com/flannel-io/flannel)


# install by helm

```shell
kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged

helm repo add flannel https://flannel-io.github.io/flannel/
helm install flannel --set podCidr="10.244.0.0/16" --namespace kube-flannel flannel/flannel
```