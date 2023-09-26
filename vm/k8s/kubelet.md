
# 参考
- [通过配置文件设置 Kubelet 参数](https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/kubelet-config-file/)
- [Kubelet 配置 (v1beta1)](https://kubernetes.io/zh-cn/docs/reference/config-api/kubelet-config.v1beta1/)



# 配置文件

/etc/systemd/system/kubelet.service.d/kubeadm.conf

```shell
KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --fail-swap-on=false
KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests
KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local
KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt
KUBELET_EXTRA_ARGS=--cgroup-driver=systemd
```


/var/lib/kubelet/kubeadm-flags.env

kubectl 使用的认证信息：
/etc/kubernetes/kubelet.conf



```shell
 tree /etc/kubernetes/
/etc/kubernetes/
├── admin.conf
├── config
├── controller-manager.conf
├── kubelet
├── kubelet.conf
├── kubelet.kubeconfig
├── manifests
│   ├── etcd.yaml
│   ├── kube-apiserver.yaml
│   ├── kube-controller-manager.yaml
│   └── kube-scheduler.yaml
├── pki
│   ├── apiserver.crt
│   ├── apiserver-etcd-client.crt
│   ├── apiserver-etcd-client.key
│   ├── apiserver.key
│   ├── apiserver-kubelet-client.crt
│   ├── apiserver-kubelet-client.key
│   ├── ca.crt
│   ├── ca.key
│   ├── etcd
│   │   ├── ca.crt
│   │   ├── ca.key
│   │   ├── healthcheck-client.crt
│   │   ├── healthcheck-client.key
│   │   ├── peer.crt
│   │   ├── peer.key
│   │   ├── server.crt
│   │   └── server.key
│   ├── front-proxy-ca.crt
│   ├── front-proxy-ca.key
│   ├── front-proxy-client.crt
│   ├── front-proxy-client.key
│   ├── sa.key
│   └── sa.pub
├── proxy
└── scheduler.conf
```
