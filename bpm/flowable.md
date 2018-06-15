

## 快速开始

```bash
mkdir -p /tmp/flowable/config
cd /tmp/flowable
wget -O config/modeler-task-idm-admin-postgres.yml https://github.com/flowable/flowable-engine/blob/master/docker/config/modeler-task-idm-admin-postgres.yml?raw=true
wget -O modeler-task-idm-admin-postgres.sh https://github.com/flowable/flowable-engine/blob/master/docker/modeler-task-idm-admin-postgres.sh?raw=true
chmod u+x modeler-task-idm-admin-postgres.sh
./modeler-task-idm-admin-postgres.sh start
```
然后浏览器访问:
- 用户名/密码: admin/test
- http://localhost:8080/flowable-idm/
- http://localhost:8888/flowable-modeler/
- http://localhost:9988/flowable-admin/
- http://localhost:9999/flowable-task/

## 参考
- [Flowable](https://www.flowable.org/)
- [spring integration](https://www.flowable.org/docs/userguide/index.html#springintegration)
