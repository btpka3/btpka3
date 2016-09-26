

# 七牛云

目前(2016)公司项目图片资源所用的CDN为 [七牛云](http://www.qiniu.com/)。但是为了防止文件命名问题（包含重命名，文件重复上传），采用的方案是：

1. 用户先上传图片到 自己的WebApp服务器
1. 自己的WebApp服务器上：

    1. 计算文件MD5，
    1. 将其MD5值作为CDN上的文件名，并上传
    1. WebApp服务器上并不存储文件内容，仅仅在数据库内只保留元信息。 

1. Web前端再通过JS，使用七牛云的[图片处理API](http://developer.qiniu.com/code/v6/api/kodo-api/image/index.html)修改URL参数来适应不同的手机屏幕。


缺点：时不时被反馈用户上传慢，因此在考虑使用浏览器端计算文件MD5值。

七牛云的[直传API](http://developer.qiniu.com/code/v6/api/kodo-api/up/upload.html) 支持通过[魔法变量](http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#magicvar)来自动使用七牛云ETAG [`$(etag)`](http://developer.qiniu.com/article/kodo/kodo-developer/appendix.html#qiniu-etag) 来设定文件名。




