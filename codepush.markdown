
[CodePush](http://microsoft.github.io/code-push/)、 [CodePush-cli](https://github.com/Microsoft/code-push/tree/master/cli)

```
npm install -g code-push-cli

# 第一次使用
code-push register
code-push app add <appName>
# 使用 cordova
code-push release <appName> <package> <appStoreVersion>
code-push logout


# 重复使用
code-push login
...
code-push logut
```