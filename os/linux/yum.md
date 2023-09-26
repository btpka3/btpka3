
替代品： [dnf](https://docs.fedoraproject.org/en-US/quick-docs/dnf/)

```bash
# 查询安装的所有 RPM 包
rpm -qa

# 查询给定 RPM 包中包含的文件
rpm -ql logrotate

# 查询给定文件是属于哪个 RPM 包
rpm -ql /etc/logrotate.conf

# 解压 rpm 包
rpm2cpio php-5.1.4-1.esp1.x86_64.rpm | cpio -idmv
```
