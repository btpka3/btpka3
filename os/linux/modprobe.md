
# 简介
modprobe是linux的一个命令，可载入指定的个别模块，或是载入一组相依的模块。modprobe会根据depmod所产生的相依关系，决定要载入哪些模块。
若在载入过程中发生错误，在modprobe会卸载整组的模块


```bash
# 列出所加载的模块列表
lsmod
cat /proc/modules
```


# 参考

- lsmod
- depmod
- modprobe
