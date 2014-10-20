

[centos - selinux](http://wiki.centos.org/zh/HowTos/SELinux)

# 模式

|mode       |description|
|-----------|---|
|Enforcing  |启用 SELinux，如违规会拒绝访问及记录|
|Permissive |启用 SELinux，如违规，仅仅记录，但不会阻止|
|Disabled   |禁用SELinux |

```sh
# 持久设置，重启生效
vi /etc/selinux/config 

# 临时启用，重启失效
setenforce 1

# 查看当前启用状态
getenforce

```

# 