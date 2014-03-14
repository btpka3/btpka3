鉴于github使用的部分资源在国内访问不稳定，打算将在github上的wiki迁移到这里。

```
git clone --bare  https://github.com/btpka3/btpka3.github.com.wiki.git
cd btpka3.github.com.wiki.git
git push --mirror http://git.oschina.net/btpka3/btpka3.wiki.git
cd ..
git clone http://git.oschina.net/btpka3/btpka3.wiki.git
cd btpka3.wiki
echo Welcome to the btpka3 wiki! > Home.markdown
git add Home.markdown
git commit -m "recover home page for wiki"
git push
```

本地编辑wiki [参考](http://git.oschina.net/xieyajie/XDUI/wikis/git_access)
使用[gollum](https://github.com/gollum/gollum)