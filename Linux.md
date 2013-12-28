## What OPTIONS is the running kernel using?
[See this](http://www.walkernews.net/2008/11/21/how-to-check-what-kernel-build-options-enabled-in-the-linux-kernel/):
```sh
cat /boot/config-$(uname -r)
```

## Loadable kernel module
[See this](http://www.tldp.org/HOWTO/html_single/Module-HOWTO/)
```sh

# show module info
modinfo module_name

# list loaded modules
lsmod
less /proc/modules

# install module
insmod module_name

# unstall module
rmmod module_name
```