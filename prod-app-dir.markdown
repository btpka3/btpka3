

```sh
/data/software                                   # 服务器需要安装的文件包都先放到这里 

# 以下文件的所有者都应当是 www :  chown -R www:www /data/app/${app-name}
/data/app/${app-name}/scp.sh                     # 负责从207 copy war包到upload目录
/data/app/${app-name}/deploy.sh                  # 负责起停tomcat，并将war包拷贝到 tomcat目录下
/data/app/${app-name}/upload/                    
/data/app/${app-name}/apache-tomcat-x.x.x/

# 日志
/home/www/logs/${app-name}/

# root 所有
/etc/init.d/${app-name}
chown root:root /etc/init.d/${app-name}
chomd oug+x /etc/init.d/${app-name}
```