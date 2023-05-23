- [kubernetes](https://kubernetes.io/)
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

# 基础命令
```shell
kubectl get       # 获取资源列表
  kubectl get ns           # namespace
  kubectl get rc           # rc : replication controller
  kubectl get nodes
  kubectl get deployments
  kubectl get replicasets
  kubectl get pods
  kubectl get events
  kubectl get services

kubectl describe  # 描述资源详情
kubectl logs      # 获取 container 的日志
kubectl exec      # 在 container 里执行命令

kubectl proxy     # 开启一个代理，以便对给定的 Pod 进行 debug、交互。
export POD_NAMES="$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')"
echo Name of the Pod: $POD_NAMES
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/

kubectl logs ${POD_NAME}
kubectl exec "$POD_NAME" -- env
kubectl exec -ti $POD_NAME -- bash

kubectl scale    # 扩缩容
kubectl autoscale
kubectl rollout

kubectl attach
kubectl cp
kubectl expose

```

# 命名
"nginx-deployment-66f8758855-5qtqg"
- "nginx-deployment" : Deployment 名称
- "66f8758855"       : ReplicaSet 名称
- "5qtqg"            :



# Hello MiniKube

```shell

minikube start
minikube dashboard

kubectl get nodes

kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.39 -- /agnhost netexec --http-port=8080
kubectl get deployments
kubectl get replicasets

kubectl get pods
kubectl describe pods

kubectl get events
kubectl config view

kubectl expose deployment hello-node --type=LoadBalancer --port=8080
kubectl get services
minikube service hello-node

minikube addons list
minikube addons enable metrics-server
kubectl get pod,svc -n kube-system
minikube addons disable metrics-server

kubectl delete service hello-node
kubectl delete deployment hello-node

minikube stop

# Optional
minikube delete
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
