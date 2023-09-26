


```shell
# 安装一个 nginx
helm install my-nginx bitnami/nginx --version 15.0.1

# 启动隧道，如果有密码提示，则输入 host操作系统（比如MacOS) 当前用户的 登录密码，执行 sudo 操作 修改路由配置
minikube tunnel

# 观察输出，确保 EXTERNAL-IP 有具体的IP值，而不是 <pending> 状态
kubectl get svc --namespace default -w my-nginx

# 获取 host操作系统（比如MacOS) 上浏览器要访问的url 
# 示例输出：  http://10.100.50.248:80
export SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].port}" services my-nginx)
export SERVICE_IP=$(kubectl get svc --namespace default my-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "http://${SERVICE_IP}:${SERVICE_PORT}"

# 浏览器访问上述URL
```

# dashboard

```shell
minikube dashboard
```