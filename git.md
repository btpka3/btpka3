# install gitlab
see [here](https://github.com/gitlabhq/gitlabhq/blob/master/doc/install/installation.md)


```txt
1. 从gitlab上git clone操作时，如果https链接出错，而已将地址换成http的。
2. vi ～/gitlab-shell/config.yml
修改redis的连接地址
3. 使用远程Postgres，设置用户的密码
```


# 手动安装
由于gitlab预编译的二进制包（*.rpm）包含了所有依赖，
Ubuntu下的手动安装请参考[这里](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md)。
CentOS下的手动安装请参考[这里](https://gitlab.com/gitlab-org/gitlab-recipes/tree/master/install/centos)。


## install EPEL

```sh
wget -O /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 https://www.fedoraproject.org/static/0608B895.txt
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

# 确认key已经正确安装
rpm -qa gpg*
gpg-pubkey-0608b895-4bd22942

[root@localhost ~]# rpm -ivh http://mirrors.yun-idc.com/epel/6/i386/epel-release-6-8.noarch.rpm 
```
## add PUIAS Computational repository

```sh
wget -O /etc/yum.repos.d/PUIAS_6_computational.repo https://gitlab.com/gitlab-org/gitlab-recipes/raw/master/install/centos/PUIAS_6_computational.repo

wget -O /etc/pki/rpm-gpg/RPM-GPG-KEY-puias http://springdale.math.ias.edu/data/puias/6/x86_64/os/RPM-GPG-KEY-puias
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-puias

rpm -qa gpg*
gpg-pubkey-41a40948-4ce19266
```

```sh
yum repolist
```

## 安装所需的必要工具

```sh
yum -y update
yum -y groupinstall 'Development Tools'
yum -y install readline readline-devel ncurses-devel gdbm-devel glibc-devel tcl-devel openssl-devel curl-devel expat-devel db4-devel byacc sqlite-devel libyaml libyaml-devel libffi libffi-devel libxml2 libxml2-devel libxslt libxslt-devel libicu libicu-devel system-config-firewall-tui redis sudo wget crontabs logwatch logrotate perl-Time-HiRes
``` 


# first login
```sh
su - git
cd /home/git/gitlab
bundle exec rake db:seed_fu RAILS_ENV=production
== Seed from /home/git/gitlab/db/fixtures/production/001_admin.rb
2014-03-26T06:51:38Z 13826 TID-aw08k INFO: Sidekiq client with redis options {:url=>"redis://localhost:6379", :namespace=>"resque:gitlab"}

Administrator account created:

login.........admin@local.host
password......5iveL!fe

```

# LDAP login

```sh
vi config/gitlab.yml
  ldap:
    enabled: true
    host: '10.1.10.2'
    port: 389
    uid: 'userPrincipalName' # "sAMAccountName"
    method: 'plain' # "tls" or "ssl" or "plain"
    bind_dn: 'CN=张亮亮,OU=研发中心,OU=信息事业部,OU=通策集团,DC=tcgroup,DC=local'
    password: 'ZLL password'
    allow_username_or_email_login: false
    base: 'DC=TCGROUP,DC=LOCAL'
    user_filter: '(objectCategory=CN=Person,CN=Schema,CN=Configuration,DC=tcgroup,DC=local)'

bundle exec rake gitlab:ldap:check RAILS_ENV=production
```

# 7788
## show gitlab versions

```sh
[root@localhost ~] su - git
[git@localhost ~] cd gitlab
[git@localhost gitlab] bundle exec rake gitlab:env:info RAILS_ENV=production
[git@localhost gitlab] git describe --tags
```
