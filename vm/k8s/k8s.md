- [kubernetes](https://kubernetes.io/)
- kubernetes: [入门/生产环境](https://kubernetes.io/zh-cn/docs/setup/production-environment/)
    - [kubeadm](https://kubernetes.io/zh-cn/docs/setup/production-environment/tools/kubeadm/)
    - [kubespray](https://github.com/kubernetes-sigs/kubespray) 等同于预设了一些 ansible 的配置文件。
    - [kops](https://github.com/kubernetes/kops) : 简化在云厂商上创建 k8s 集群
    - [Kubespray vs. Kops vs. kubeadm](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/comparisons.md)
- kuboard.cn: [使用 KuboardSpray 安装kubernetes_v1.23.1:历史文档](https://kuboard.cn/install/install-k8s.html#kuboard-spray)
- [CNCF: Cloud Native Computing Fundation](https://www.cncf.io/)
- [Helm](https://helm.sh/docs/topics/charts/)
- [Kubernetes API](https://kubernetes.io/docs/reference/kubernetes-api/)
- [kind : K8s in docker](https://kind.sigs.k8s.io/)
- [Minikube](https://kubernetes.io/docs/tutorials/hello-minikube/)
- [moby/hyperkit](https://github.com/moby/hyperkit)
- [killercoda.com](https://killercoda.com/playgrounds/scenario/kubernetes)
- [CKA: Certified Kubernetes Administrator](https://www.cncf.io/certification/cka/) : Kubernetes 管理员认证
- [CKAD: Certified Kubernetes Application Developer](https://www.cncf.io/certification/ckad/) :  Kubernetes 应用程序开发人员认证
- [CKS: Certified Kubernetes Security Specialist](https://www.cncf.io/certification/cks/) :  Kubernetes 应用程序开发人员认证
- kubernetes SIG : kubernetes Special Interest Group
- java:
  - client
    - 官方java client [io.kubernetes:client-java](https://github.com/kubernetes-client/java)
    - [~~fabric8~~](https://fabric8.io/)  # 已废弃
  - Maven plugin
    - [~~fabric8-maven-plugin~~](https://maven.fabric8.io/) # 已废弃
    - eclipse jkube : [kubernetes-maven-plugin](https://github.com/eclipse/jkube)
    -
- [istio.io](https://istio.io/latest/zh/docs/concepts/traffic-management/)
- [k3s](https://k3s.io/)
- [k3d](https://k3d.io/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [higress](https://github.com/alibaba/higress)
- [OpenKruise](https://openkruise.io/docs/user-manuals/cloneset/)
- [K8S集群内Pod如何与本地网络打通实现debug](https://cloud.tencent.com/developer/article/1836304)
- [Telepresence](https://github.com/telepresenceio/telepresence)  # 个人开发机与k8s集群网络互联
- [Ambassador Cloud](https://www.getambassador.io/products/ambassador-cloud)
- [killercoda](https://killercoda.com/account/membership) # 交互式学习
- 阿里云
    - [获取集群KubeConfig并通过kubectl工具连接集群](https://help.aliyun.com/zh/ack/ack-managed-and-ack-dedicated/user-guide/obtain-the-kubeconfig-file-of-a-cluster-and-use-kubectl-to-connect-to-the-cluster?spm=a2c4g.11186623.0.0.33097961DQ7rje)

```yaml
# application/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: nginx-deployment
spec:
    selector:
        matchLabels:
            app: nginx
    replicas: 2
    template:
        metadata:
            labels:
                app: nginx
        spec:
            containers:
                - name: nginx
                  image: nginx:1.14.2
                  ports:
                      - containerPort: 80
```

# context, config
```shell
# 如果有多个 k8s 集群，比如 minikube, kind, 或者 远程k8s集群
# 会有多个 context ， 即 ~/.kube 目录下有多个配置文件
# 可以通过该命令查看
kubectl config get-contexts

# 可以通过该命令切换
kubectl config use-context kind-kind

kubectl config view

# 确保下面命令能列出该表格中已经启用的 机器列表
kubectl --kubeconfig ~/.kube/config_daily get node

# 如果不想每次都指定 --kubeconfig 参数，可以设置下环境变量 KUBECONFIG
export KUBECONFIG=~/.kube/config_daily

```




```shell
brew install hyperkit
brew install minikube
# automatically selected the hyperkit driver. Other choices: qemu2, virtualbox, ssh, podman (experimental)
# 🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

brew install kubernetes-cli
brew install kind
brew install k3d  # k3s

kubectl apply -f https://k8s.io/examples/application/deployment.yaml
```

# 链接到既有K8S集群

```shell
# k8s集群配置信息：
scp root@11.164.234.212:/root/.kube/config ~/.kube/config_daily

# 确保下面命令能列出该表格中已经启用的 机器列表
kubectl --kubeconfig ~/.kube/config_daily get node

# 如果不想每次都指定 --kubeconfig 参数，可以设置下环境变量 KUBECONFIG
export KUBECONFIG=~/.kube/config_daily
kubectl get node

# 错误: ImagePullBackOff : 通过以下命令查看详情
kubectl describe pod mtee3-deployment-774f644856-j8ghp
```


# statefulset

```shell
kubectl delete statefulset nacos
kubectl get statefulset nacos

kubectl rollout restart deployment <deployment-name>
kubectl rollout restart statefulset <statefulset-name>
kubectl scale --replicas=2 statefulset <statefulset-name>
kubectl get pod -o wide --selector app=nacos

https://www.coder.work/article/7315538
```


# 命名
"nginx-deployment-66f8758855-5qtqg"
- "nginx-deployment" : Deployment 名称
- "66f8758855"       : ReplicaSet 名称
- "5qtqg"            :



# Hello MiniKube

```shell

minikube ssh

minikube start --container-runtime=cri-o
minikube addons enable metrics-server
minikube -p minikube podman-env
eval $(minikube -p minikube podman-env)

minikube dashboard

kubectl get nodes

kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.39 -- /agnhost netexec --http-port=8080
kubectl get deployments
kubectl get replicasets
kubectl delete deployment nginx-deployment

kubectl get pods
kubectl describe pods

kubectl get events
kubectl config view

kubectl get endpointslices

kubectl expose deployment hello-node --type=LoadBalancer --port=8080
kubectl get services
minikube service hello-node
kubectl delete service jkube-maven-sample-zero-config

kubectl get endpointslices


minikube addons list
minikube addons enable metrics-server
kubectl get pod,svc -n kube-system
minikube addons disable metrics-server

kubectl delete service hello-node
kubectl delete deployment hello-node

minikube stop

# Optional
minikube delete


kubectl plugin list
```


# 概念

## Pod
当创建一个 Deployment 时， K8s 创建一个 Pod 来持有应用实例。
一个 Pod 代表：
- 一组 应用容器（1个或多个）
- 以及这一组容器间共享的资源
  - Shared storage, as Volumes
  - Networking, as a unique cluster IP address
  - Information about how to run each container, such as the container image version or specific ports to use

## Node
Pod 总是运行在 Node 上。Node 在K8s中可以是一个 虚拟机 也可以是一个物理机。



# KIND

```shell
kind create cluster
kind get clusters
kubectl cluster-info --context kind-kind
```


# error
ImagePullBackOff



# secret

```plain
Opaque	                                用户定义的任意数据
kubernetes.io/service-account-token	    服务账号令牌
kubernetes.io/dockercfg	                ~/.dockercfg 文件的序列化形式
kubernetes.io/dockerconfigjson	        ~/.docker/config.json 文件的序列化形式
kubernetes.io/basic-auth	            用于基本身份认证的凭据
kubernetes.io/ssh-auth	                用于 SSH 身份认证的凭据
kubernetes.io/tls	                    用于 TLS 客户端或者服务器端的数据
bootstrap.kubernetes.io/token	        启动引导令牌数据
```


## 类型



## 创建-通过 kubectl 命令

```shell
kubectl create secret \
    docker-registry yourSecretName \
    --docker-server=registry.your.com \
    --docker-username=zhang3 \
    --docker-password=xxxPassword

kubectl describe secret yourSecretName
kubectl get      secret yourSecretName -o yaml
kubectl get      secret yourSecretName -o jsonpath="{.data['\.dockerconfigjson']}" | base64 -d | jq
kubectl get      secret yourSecretName -o custom-columns=NAME:.data.'\.dockerconfigjson'
```

```json
{
  "auths": {
    "registry.xxx.com": {
      "username": "zhang3@xxx.com",
      "password": "xxxPassword",
      "email": "zhang3@xxx.com",
      "auth": "xxxBase64xxx"
    }
  }
}
```

## 创建-通过 yaml 文件

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
# base64 编码
data:
  username: YWRtaW4=
  password: MTIzNDU2Cg==
# 明文
# 相同的 key 出现在 stringData, data 中时， 则使用 stringData 中的值
stringData:
  username: admin
  password: "123456"
```


## 使用
- 作为挂载到一个或多个容器上的卷 中的文件。
- 作为容器的环境变量
- 由 kubelet 在为 Pod 拉取镜像时使用。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: mypod
      image: redis
      volumeMounts:
        - name: foo
          mountPath: "/etc/foo"
          readOnly: true
  volumes:
   - name: foo
     secret:
       secretName: mysecret
       optional: true
```

# ConfigMap

## 通过 yaml 定义

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-demo
data:
  # property-like keys; each key maps to a simple value
  player_initial_lives: "3"
  ui_properties_file_name: "user-interface.properties"

  # file-like keys
  game.properties: |
    enemy.types=aliens,monsters
    player.maximum-lives=5
  user-interface.properties: |
    color.good=purple
    color.bad=yellow
    allow.textmode=true
```

```shell
kubectl apply -f xxx.yaml
kubectl -n default get configmap game-demo
# 查看 configMap 的 内容
kubectl -n default describe configmap game-demo
# 运行态编辑 configMap
kubectl -n default edit configmap game-demo
```


## 使用
- 作为容器的命令和参数
- 作为容器的环境变量
- 将其作为只读数据卷中的文件挂载
- 在容器中通过 k8s API 读取其内容

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-demo-pod
spec:
  containers:
    - name: demo
      image: alpine
      command: ["sleep", "3600"]
      env:
        # Define the environment variable
        - name: PLAYER_INITIAL_LIVES # Notice that the case is different here
                                     # from the key name in the ConfigMap.
          valueFrom:
            configMapKeyRef:
              name: game-demo           # The ConfigMap this value comes from.
              key: player_initial_lives # The key to fetch.
        - name: UI_PROPERTIES_FILE_NAME
          valueFrom:
            configMapKeyRef:
              name: game-demo
              key: ui_properties_file_name
      volumeMounts:
        - name: config
          mountPath: "/config"
          readOnly: true
  volumes:
    - name: config
      configMap:
        # Provide the name of the ConfigMap you want to mount.
        name: game-demo
        # An array of keys from the ConfigMap to create as files
        items:
          - key: "game.properties"
            path: "game.properties"
          - key: "user-interface.properties"
            path: "user-interface.properties"
```


# volume/storage


## PersistentVolume : PV



```shell
kubectl get pv
# Status : Bound/在用
# Claim  : 是由哪个 PersistentVolumeClaim 创建的
kubectl describe pv pvc-5d62783b-7720-43a2-add3-8204d61120d9
```

- ReadWriteOnce:



```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```

## PersistentVolumeClaim : PVC

```shell
kubectl get pvc
# 检查
# Status  : Bound/在用
# Used By : 被哪个pod使用
kubectl describe pvc blackcat-data-blackcat-0
```


# event

```shell
kubectl get event
kubectl get event  --field-selector involvedObject.name=nacos-2 --sort-by=".metadata.managedFields[0].time"
kubectl logs nacos-2
```


# namespace

```shell
kubectl create ns xxxNameSpace
kubectl get ns
```

# sc : storage class

```shell
kubectl get sc
```

# kubelet



# controller

```shell
# 检查所有pod
kubectl get pods --all-namespaces
```


# service

domain: `${serviceName}.${namespace}.svc.cluster.local`
示例： my-service.prod.svc.cluster.local

## service NodePort


```shell
# 获取 所有 type=NodePort 的 service 信息
kubectl get service -o json | jq -r '
    def to_port: (.port|tostring) + ":" + (.nodePort|tostring) + "/" + (.protocol|tostring);

    ["NAME", "TYPE", "CLUSTER-IP", "PORT(S)", "SELECTOR"],
    (
       .items[]
       | select(.spec.type=="NodePort")
       | [
          .metadata.name,
          .spec.type,
          .spec.clusterIP,
          (.spec.ports|map(.|to_port)|join(",")),
          (.spec.selector|to_entries|map(.key + "=" + .value)|join(","))
         ]
    )
    | @tsv
' | column -ts $'\t'
```


# addon

```shell
# 获取所有 k8s 的 pod
kubectl get pod -n kube-system
kubectl get service -n kube-system
```

## coreDns
推荐使用 helm 方式安装 , 从 k8s 1.21 开始，不再支持 kube-dns
https://github.com/coredns/helm


# ephemeral containers / 临时容器
[调试运行中的 Pod](https://kubernetes.io/zh-cn/docs/tasks/debug/debug-application/debug-running-pod/)


```shell
kubectl run ephemeral-demo --image=registry.k8s.io/pause:3.1 --restart=Never
# 以下命令将报错
kubectl exec -it ephemeral-demo -- sh
# 进行 debug
kubectl debug -it ephemeral-demo --image=busybox:1.28 --image-pull-policy=IfNotPresent --target=ephemeral-demo
```




# install on alpine
https://dev.to/xphoniex/how-to-create-a-kubernetes-cluster-on-alpine-linux-kcg

```shell
echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing/"     >> /etc/apk/repositories

apk add kubernetes@testing
apk add docker@community
apk add cni-plugins@testing
```

# install on fedora

- [安装 kubeadm](https://kubernetes.io/zh-cn/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [How to install Kubernetes cluster on CentOS 8](https://upcloud.com/resources/tutorials/install-kubernetes-cluster-centos-8)

## 准备操作系统
```shell
docker run --rm docker.io/library/fedora:38 cat /etc/os-release
docker run --name my-k8s-master -it docker.io/library/fedora:38 bash -l
docker ps -a
docker exec -it my-k8s-master bash -l
```

## 安装

### 在所有Master、Worker 上都准备好初始化工作
```shell
cat /etc/os-release

dnf repolist
dnf -y upgrade

# disable SELinux enforcement
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# 允许透明伪装，方便 k8s pod 之间的 Virtual Extensible LAN (VxLAN) 流量
dnf install kmod
modprobe br_netfilter

# 允许 ip 伪装
dnf install firewalld
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload

# Set bridged packets to traverse iptables rules.
dnf install procps-ng
mkdir -p /etc/sysctl.d
cat > /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

# 禁用内存交换，以提高性能
swapoff -a
```

### 在所有Master、Worker 上都安装docker
[Install Docker Engine on Fedora](https://docs.docker.com/engine/install/fedora/#prerequisites)

```shell
# 删除旧的安装
dnf remove \
        docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine

dnf install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

dnf install \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

systemctl start docker
docker run hello-world

docker version
docker images
```

## 在所有Master、Worker 上都安装 kubernetes

https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/

```shell
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
```


# Job

