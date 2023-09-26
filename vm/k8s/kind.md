[kind](https://kind.sigs.k8s.io/)

```shell
brew install kind

kind create cluster
kind delete cluster
kind get clusters
kubectl cluster-info --context kind-kind

kind load docker-image docker.io/library/alpine:latest

kubectl create deployment my-alpine-deployment --image=docker.io/library/alpine:latest -- tail -f /dev/null
kubectl get pod

kubectl exec -it my-alpine-deployment-54fbcb8dc-6qd9h -- sh -l
```