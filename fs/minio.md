

- https://min.io/
- https://play.min.io




```shell

mkdir -p ${HOME}/minio/data

echo 111 > ${HOME}/minio/data/a.txt


docker run \
   -p 9000:9000 \
   -p 9090:9090 \
   --user $(id -u):$(id -g) \
   --name minio1 \
   -e "MINIO_ROOT_USER=ROOTUSER" \
   -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
   -v ${HOME}/minio/data:/data \
   quay.io/minio/minio server /data --console-address ":9090"


# 浏览器访问: http://127.0.0.1:9000
```
