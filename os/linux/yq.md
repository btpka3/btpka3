
https://github.com/mikefarah/yq

~~https://github.com/kislyuk/yq~~



```
brew install yq
```


```shell
# 输出所有的 maven profile id
yq  -o p '.project.profiles.profile[].id' /Users/zll/data0/work/git-repo/ali/ali_security/arm-mbus/mbus-web/pom.xml | sort

# 输出所有子pom.xml 中 parent.version
find . -type f -name "pom.xml" -exec  bash -c 'echo {} `yq -o a ".project.parent.version" {}` 111' \;
find . -type f -name "pom.xml"  | xargs  -I{} -S 1024000 bash -c 'echo  "{} `yq -o a ".project.parent.version" {}`"'






find . -type f -name "pom.xml" | xargs -I '{}'  bash -c 'echo -n {} ;  echo 111 ;'
 yq -o a '.project.parent.version'

find . -type f -name "pom.xml" | xargs yq -o a '.project.parent.version'

yq -o a '.project.parent.version' /Users/zll/data0/work/git-repo/ali/dangqian.zll/gong9-mw/pandora/tddl/pandora-tddl-impl-mysql/pom.xml

ls *.markdown | xargs -I '{}'  bash -c 'mv {} `basename {} .markdown`.md'

```

