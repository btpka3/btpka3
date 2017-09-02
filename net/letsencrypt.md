


# Let's Encrypt
所有相关资料均请参考 [Let's Encrypt](https://letsencrypt.org/) 官网。

下面流程是假设 环境是CentOS 7 和Nginx/Tengine, 并使用 [Certbot](https://certbot.eff.org/#centosrhel7-nginx)

1. 等到客户访问流量最少的时间段，比如凌晨，如有可能的话，请提前通知客户。
1. 登录域名服务商的管理后台
    1. 记录并备份要新建/renew(更新)https证书的域名的原有配置。
    1. 修改要 新建/renew(更新)https证书的域名（不管是A记录，还是CNAME记录，使之最终查询到的IP为你管理服务器的公网IP）
1. 登录到服务器，

    1. 初次安装（仅一次）

        ```
        yum install epel-release
        yum install certbot
        ```
    1. 停止 nginx/tengine

        ```
        systemctl stop tengine
        ```
    1. 创建证书

        ```
        certbot certonly
        # 选择第二种 "2 Automatically use a temporary webserver (standalone)"
        # 输入要创建的证书的域名，用逗号或空格分隔。
        ```

    1. 更新证书

        ```
        certbot renew --dry-run
        # 选择第二种 "2 Automatically use a temporary webserver (standalone)"
        # 输入要创建的证书的域名，用逗号或空格分隔。
        ```


## 目录结构

```text
/etc/letsencrypt/live/accounts      
/etc/letsencrypt/live/archive       # 包含之前的证书（含吊销的）
/etc/letsencrypt/live/csr   
/etc/letsencrypt/live/keys
/etc/letsencrypt/live/live          # 当前在用的证书，一般均为符号链接
/etc/letsencrypt/live/renewal
```

# certbot

```bash
# 查看所有详细帮助
certbot --help all

certbot \
    register \
    -n \
    --email admin@kingsilk.net \
    --eff-email \
    --agree-tos


# 列出所有证书
certbot certificates 

# 吊销证书 (注意：吊销后本地文件仍存在)
certbot revoke --cert-path /etc/letsencrypt/live/test.kingsilk.club/fullchain.pem 

# 删除证书
certbot delete \
    -n \
    --cert-name test.kingsilk.club

# 更新符号链接
certbot update_symlinks

# 手动通过 DNS TXT 记录验证并获取证书
# 非交互模式下必须使用 --manual-auth-hook 
# https://help.aliyun.com/document_detail/29754.html?
certbot certonly \
    --manual \
    --manual-public-ip-logging-ok \
    --preferred-challenges dns \
    -d kingsilk.club
 
# 更新证书 
certbot renew 
```

# certbot in docker

see [Running with Docker](https://certbot.eff.org/docs/install.html#running-with-docker)





```bash
sudo mkdir -p /etc/letsencrypt 
sudo mkdir -p /var/lib/letsencrypt

docker run -it  \
    --name certbot \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot certonly
```
