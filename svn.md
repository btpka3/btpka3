
# Eclipse 插件安装
[参考](http://www.eclipse.org/subversive/installation-instructions.php )

NOTICE: 如果svn升级，比如从1.7升级到1.8，需要重新执行一下步骤，并uninstall旧的插件。


## 安装 Subversive 插件
默认在Eclipse中的Update Site中都有一个官方的更新站点，比如：`Kepler - http://download.eclipse.org/releases/kepler`。
选中之后，在 “Collaboration” 安装所需的 Subversive 特性即可。重启Eclipse。

## 安装SVN Connector
可以从SVNKit或者JavaHL中二选一即可。SVNKit是纯JAVA编写。而JavaHL是调用外部库。
到[该网址](http://www.polarion.com/products/svn/subversive/download.php)使用与Eclipse相对应的更新站点，再安装SVNKit或者JavaHL即可。

如果安装的是JavaHL，还需要进行以下操作

1.  Ubuntu

    ```sh
    # 可以加 -s 参数先模拟安装，并查看相关信息。
    [me@localhost ~]$ sudo apt-get install libsvn-java
    # 查找安装类库的路径
    [me@localhost ~]$ apt-file search libsvnjavahl-1.so 
    [me@localhost ~]$ ll /usr/lib/x86_64-linux-gnu/jni/
    # 修改Eclipse配置文件，追加外部库的路径
    [me@localhost ~]$ vi ~/work/sts-3.4.0.RELEASE/STS.ini
        -Djava.library.path=/usr/lib/x86_64-linux-gnu/jni  # 追加该行
    
    # 防止在Eclipse中出现 Invalid thread access错误。
    [me@localhost ~]$ vi ~/.subversion/config 
      password-stores = 

    ```
1. Windows
    TODO



# 在当前work目录下update一个本地不存在的目录

```sh
cd /local/work/dir/

svn update --depth=immediates
#--depth : empty, files, immediates, infinity

cd newDownloadDir
svn update --set-depth infinity
```

 