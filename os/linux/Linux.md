


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


pgm -A -b -p 20 $(armory -leg mtee3.prod.elemehost) '
FGCCOUNT=$(grep "2023-12-09T11:0" /home/admin/logs/gc.log | grep  "Pause Full (Allocation Failure)"  | wc -l) ;
if [ "${FGCCOUNT}" -gt 0 ] ; then echo "$(hostname) HAS_FGC ${FGCCOUNT}" ; else  echo "$(hostname) NO_FGC" ; fi
 '  > a.log



33.103.52.130 : 1698
33.42.172.113 : 1206
33.68.142.138 : 706
33.39.169.146 : 563
33.103.54.1 : 149

33.42.172.113 : 323
33.68.142.138 : 251
33.103.54.1 : 28
33.7.131.3 : 7
33.102.62.76 : 3
```
