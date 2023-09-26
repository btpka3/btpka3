
https://github.com/mikefarah/yq

~~https://github.com/kislyuk/yq~~



```
brew install yq
```


```shell
# 输出所有的 maven profile id
yq  -o p '.project.profiles.profile[].id' /Users/zll/data0/work/git-repo/ali/ali_security/arm-mbus/mbus-web/pom.xml | sort

```

