

- [kubeadm Configuration (v1beta3)](https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/)
- [kubeadm init](https://kubernetes.io/zh-cn/docs/reference/setup-tools/kubeadm/kubeadm-init/)
    - [结合一份配置文件来使用 kubeadm init](https://kubernetes.io/zh-cn/docs/reference/setup-tools/kubeadm/kubeadm-init/#config-file)
- [kubeadm init phase](https://kubernetes.io/zh-cn/docs/reference/setup-tools/kubeadm/kubeadm-init-phase/)
- [kubeadm 配置 (v1beta3)](https://kubernetes.io/zh-cn/docs/reference/config-api/kubeadm-config.v1beta3/)



```shell
kubeadm config print init-defaults
kubeadm config print join-defaults

kubeadm init --config kubeadm.yaml

```

# container runtime

```plain
Runtime	                            Path to Unix domain socket
containerd	                        unix:///var/run/containerd/containerd.sock
CRI-O	                            unix:///var/run/crio/crio.sock
Docker Engine (using cri-dockerd)	unix:///var/run/cri-dockerd.sock

```

# config

```shell
kubeadm config images list --config kubeadm.yaml
kubeadm config images pull --config kubeadm.yaml
kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock
```

# kubeadm init phase

## preflight

```shell
kubeadm init phase preflight --config kubeadm.yaml
```


# init

```shell
# 使用配置文件
sudo kubeadm init --config kubeadm.yaml

# 使用命令行
sudo kubeadm init \
    --apiserver-advertise-address=192.168.56.5 \
    --service-cidr=10.96.0.0/12  \
    --pod-network-cidr=10.244.0.0/16 \ 
    --kubernetes-version=1.26.7 \
    --service-dns-domain=cluster.local \
    --node-name=my-fedora2


systemctl restart kubelet
kubectl get node

journalctl -xeu kubelet
journalctl -f -u kubelet


kubectl -n kube-system get deployment coredns -o yaml 
kubectl -n kube-system logs coredns-787d4945fb-knrqg 
https://coredns.io/plugins/loop#troubleshooting
# 修改 /etc/resolv.conf  确保 nameserver 不要是本地地址. 
#比如： nameserver 223.5.5.5
systemctl daemon-reload
systemctl restart kubelet

kubectl edit cm coredns -n kube-system


# 允许 master 部署 pod
# https://kubernetes.io/zh-cn/docs/reference/labels-annotations-taints/
kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
#kubectl taint nodes --all node-role.kubernetes.io/master:NoSchedule-



kubectl create deployment my-hello --image=kicbase/echo-server:1.0
kubectl get deployment my-hello
kubectl describe deployment my-hello
kubectl get pod -o wide



systemd-resolve --interface enp0s8 --set-dns 223.5.5.5 --set-domain cluster.local
```


