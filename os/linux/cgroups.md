cgroup : Control Groups

- [Chapter 1. Introduction to Control Groups (Cgroups)](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/resource_management_guide/ch01)

- man : [cgroups](https://man7.org/linux/man-pages/man7/cgroups.7.html)

version 1 : 在 linux 2.6.24 中实现
version 2 : 在 linux 4.5 中实现


```shell
# 检查 cgroup 挂载情况
mount -t cgroup
mount -t cgroup2


ll /sys/fs/cgroup
ll /sys/fs/cgroup/system.slice/docker.service
```

# v2 controllers

cpu 
cpuset
freezer
hugetlb
io
memory
pref_event
pids
rdma
