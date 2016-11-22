


## 常用命令
```
df -h # 查看磁盘空间使用状况
df -i # 查看inode数量状况（创建的文件数）
```


## What OPTIONS is the running kernel using?
[See this](http://www.walkernews.net/2008/11/21/how-to-check-what-kernel-build-options-enabled-in-the-linux-kernel/):
```bash
cat /boot/config-$(uname -r)
```

## Loadable kernel module
[See this](http://www.tldp.org/HOWTO/html_single/Module-HOWTO/)
```bash
# where is the location of kernel modules?
ls -l /lib/modules/$(uname -r)

# show module info
modinfo module_name

# list loaded modules
lsmod
less /proc/modules

# show loaded module's parameter
modprobe -c | grep module_name

# show dependencies
modprobe --show-depends module_name

# install module
insmod module_name

# unstall module
rmmod module_name
```

## commands
### tail
```
tail -f xxxFile
tailf xxxFile | grep --line-buffered --color=auto xxxKeyWord
```