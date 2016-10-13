

[centos - selinux](http://wiki.centos.org/zh/HowTos/SELinux)

[selinuxproject.org](http://selinuxproject.org/page/AdminDocs)


# 安装

一般Linux内核中都自带了，额外可能需要安装一些管理工具

```sh
yum install policycoreutils-python
```


# 模式

|mode       |description|
|-----------|---|
|Enforcing  |启用 SELinux，如违规会拒绝访问及记录|
|Permissive |启用 SELinux，如违规，仅仅记录，但不会阻止|
|Disabled   |禁用SELinux |

# 类型

|type       |description|
|-----------|---|
|targeted   |保护目标进程|
|mls        |多层次安全保护|



```sh
# 持久设置，重启生效
vi /etc/selinux/config 

# 临时启用，重启失效
setenforce 1

# 查看当前启用状态
getenforce
sestatus
```

# 示例

```sh
[root@s82 mysql]# ll -Z -d /data0/mysql
drwxr-xr-x. mysql mysql unconfined_u:object_r:etc_runtime_t:s0 /data0/mysql

#「用户：角色：类型：多层保障」
```
