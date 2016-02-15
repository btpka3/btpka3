# 安装git

## 下载
不建议使用yum安装，安装的版本过低。比如：

```sh
[root@localhost jenkins]# yum info git
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
Available Packages
Name        : git
Arch        : x86_64
Version     : 1.7.1
Release     : 3.el6_4.1
Size        : 4.6 M
Repo        : base
Summary     : Fast Version Control System
URL         : http://git-scm.com/
License     : GPLv2
Description : Git is a fast, scalable, distributed revision control system with an
            : unusually rich command set that provides both high-level operations
            : and full access to internals.
            : 
            : The git rpm installs the core tools with minimal dependencies.  To
            : install all git packages, including tools for integrating with other
            : SCMs, install the git-all meta-package.

```

如果git-scm.com下载太慢，可以从 [github](https://github.com/git/git/releases/tag/v2.2.0) 上下载。
下载tar包：git-2.0.1.tar.gz

```sh
tar zxvf git-2.0.1.tar.gz
cd git-2.0.1
less README
less INSTALL

# 需要已经安装以下软件包，部分在EPEL仓库中
yum install gcc
yum install openssl-devel
yum install libcurl-devel
yum install expat-devel
yum install perl-ExtUtils-MakeMaker
yum install tk
yum install gettext
yum install asciidoc
yum install xmlto
yum install docbook2X                                      # 需要 EPEL
ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi

yum install libicu-devel
yum install patch 
yum install gcc-c++
yum install cmake
yum install postgresql94-devel

# global install
make prefix=/usr/local all
make prefix=/usr/local install
```


# install gitlab
see [here](https://github.com/gitlabhq/gitlabhq/blob/master/doc/install/installation.md)


```txt
1. 从gitlab上git clone操作时，如果https链接出错，而已将地址换成http的。
2. vi ～/gitlab-shell/config.yml
修改redis的连接地址
3. 使用远程Postgres，设置用户的密码
```


## 手动安装
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

# 如果通过yum安装ruby的话
yum install ruby-devel

yum install nodejs
``` 

## 使用源码安装ruby

```
yum install libffi-devel

wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.1.tar.gz
tar zxvf ruby-2.2.1.tar.gz
cd ruby-2.2.1

./configure
make                                                    # 编译
make install                                          # 安装，默认安装到 /usr/local

ruby --version

gem install bundler --no-ri --no-rdoc    # 安装 bundler, 可以先参考后续使用Taobao的gem源
gem install charlock_holmes -v '0.6.9.4'     # root 安装 
gem install rugged -v '0.21.2'                      # root 安装
```

## 使用RVM安装ruby
[111](http://werein.cz/blog/en/posts/gitlab-on-rvm)
参考 [ruby](ruby)，和[Installing Gitlab with RVM](https://github.com/gitlabhq/gitlab-public-wiki/wiki/Installing-Gitlab-with-RVM)

需要将参考文档中使用到的bundle命令替换为相应的命令 ext-2.1.1_bundle，包括/etc/init.d/gitlab中的。

gitlab的官网是推荐使用编译安装ruby的，而不推荐使用rvm等其他ruby的版本控制工具进行安装。但是通过rvm安装起来确实很方便的。如果使用rvm安装ruby，请参考[1](xx)。

需要执行以下步骤：

```sh
vi /home/git/gitlab/.rvmrc
rvm use 2.1.1 2>&1 >/dev/null
```
和

```sh
vi /etc/init.d/gitlab
# 多追加了一个cd命令，以便启用rvm的hook，并设置path
PATH_PATCH="PATH=$(su $USER -s /bin/bash -l -c "cd \"$APP_PATH\"; echo \"\$PATH\"") && export PATH && "
```

## 国内ruby镜像

参考[这里](http://github.kimziv.com/2013/07/19/how-to-install-ruby-gems-in-china/)

```sh
sudo -u git -H gem sources --remove https://rubygems.org/
sudo -u git -H gem sources -a http://ruby.taobao.org/
sudo -u git -H gem sources -l
npm config set strict-ssl false

vi Gemfile
# 注释掉原有的source，使用国内镜像
#source "https://rubygems.org"
source 'http://ruby.taobao.org/'
```



## 安装gem install mysql2

先安装mysql的[yum](http://dev.mysql.com/doc/mysql-repo-excerpt/5.6/en/linux-installation-yum-repo.html)

```sh
yum install mysql-community-devel
gem install mysql2
```


## 不使用本地的postgresql时

```sh
yum install postgresql93 postgresql93-devel postgresql93-libs
```

```sh
vi /home/git/gitlab/config/gitlab.yml
# 并修改其中数据库连接信息
```

## 使用远程redis

```sh
vi /home/git/gitlab-shell/config.yml
cp /home/git/gitlab/config/resque.yml.example /home/git/gitlab/config/resque.yml
vi /home/git/gitlab/config/resque.yml
```

## first login
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

## RVM

```sh
vi /home/git/gitlab/.rvmrc
rvm use 2.1.1 2>&1 >/dev/null

vi /etc/init.d/gitlab
# 多追加了一个cd命令，以便启用rvm的hook，并设置path
PATH_PATCH="PATH=$(su $USER -s /bin/bash -l -c "cd \"$APP_PATH\"; echo \"\$PATH\"") && export PATH && "

```
 

## LDAP login

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


## 安装后的检查

```sh
su - git
cd gitlab
bundle exec rake gitlab:check RAILS_ENV=production

# 清空缓存
bundle exec rake cache:clear RAILS_ENV=production

# 检查应用状态
bundle exec rake gitlab:env:info RAILS_ENV=production

```
## 502

检查 /home/git/gitlab/conf/unicorn.rb

```
timeout 30
```

如果有使用Nginx进行反向代理，则检查nginx配置文件：

```
proxy_read_timeout 300;
proxy_connect_timeout 300;
```

## 7788
### show gitlab versions

```sh
[root@localhost ~] su - git
[git@localhost ~] cd gitlab
[git@localhost gitlab] bundle exec rake gitlab:env:info RAILS_ENV=production
[git@localhost gitlab] git describe --tags
```

admin user

```sh
less /home/git/gitlab/db/fixtures/production/001_admin.rb

```

# 导入既有的git仓库

```sh
# 先通过Web画面创建一个工程。
cd /home/git/repositories/$user/xxx
rm -fr *
git clone --mirror $URL

# 同步
git fetch -q --all -p

#cd /home/git/gitlab
#bundle exec rake gitlab:import:repos RAILS_ENV=production
```



# git 命令

## tag

```sh
git tag newTag              # 创建tag
git tag -l                  # 显示所有的tag
git checkout tags/2.4.9     # 切换到2.4.9的tag
                            # TODO 合并
```

## branch


```sh
                            # TODO 创建branch
git branch -a               # 列出所有的branch，带*号的是工作环境所在的分支
                            # TODO 切换branch
                            # TODO 合并
```

# 升级

参考[这里](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/update/upgrader.md)

备份
  
```
su - git
cd /home/git/gitlab
# 该命令会创建一个备份 /home/git/gitlab/tmp/backups/1419398073_gitlab_backup.tar
bundle exec rake gitlab:backup:create RAILS_ENV=production
```

鉴于国内无法从 https://rubygems.org/ 下载，需要现在检出最新版本的gitlab的Gemfile，并
注释掉 "#source "https://rubygems.org"，而使用淘宝镜像 "source 'http://ruby.taobao.org/'"

```
cp Gemfile /tmp/
vi /home/git/gitlab/lib/gitlab/upgrader.rb  修改当前版的 更新脚本代码

    def update_commands
      {   
        "Stash changed files" => %W(git stash),
        "Get latest code" => %W(git fetch),
        "Switch to new version" => %W(git checkout v#{latest_version}),
        "using taobao ruby soruce " => %W(cp /tmp/Gemfile .),   # 插入该行，在获取最新代码后，替换掉Gemfile，使用taobao的ruby源。 
        "Install gems" => %W(bundle),
        "Migrate DB" => %W(bundle exec rake db:migrate),
        "Recompile assets" => %W(bundle exec rake assets:clean assets:precompile),
        "Clear cache" => %W(bundle exec rake cache:clear)
      }   
    end 
```

# 修改css

```
vi /home/git/gitlab/app/assets/stylesheets/generic/forms.scss  # Edit in fullscreen 的css
# 或者 vi /home/git/gitlab/app/assets/stylesheets/generic/zen.scss

  input:checked ~ .zen-backdrop {
    background-color: white;
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 1031;

    textarea {
      border: none;
      box-shadow: none;
      border-radius: 0;
      color: #000;
      /*font-size: 20px;*/                 -- 注释掉该行
      /*line-height: 26px;*/               -- 注释掉该行
      /*padding: 30px;*/                   -- 注释掉该行
      display: block;
      outline: none;
      resize: none;
      height: 100vh;
      /*max-width: 900px;*/                -- 注释掉该行
      max-width: 90%;                      -- 增加该行
      margin: 0 auto;
      border: 1px solid grey;              -- 增加该行
    }   
  }

sudo -u git -H bundle exec rake assets:clean assets:precompile cache:clear RAILS_ENV=production

sudo service gitlab start

```


# 账户解锁

参考 ： [devise](https://github.com/plataformatec/devise)-3.2.4/lib/devise/models/lockable.rb

```sh
mysql -h 192.168.101.80 -u git -pXXXX gitlabhq_production

update set failed_attempts=0,locked_at=null where username='xxx'

```	

# STMP

参考[这里](http://elijahpaul.co.uk/using-an-smtp-server-with-gitlab/) :

## 修改 `` :

```
vi config/environments/production.rb
# config.action_mailer.delivery_method = :sendmail
config.action_mailer.delivery_method = :stmp

cp config/initializers/smtp_settings.rb.sample config/initializers/smtp_settings.rb
vi config/initializers/smtp_settings.rb
```

 
# 强制 rebase
参考:

1. 《[Gitlab : Custom Git Hooks](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/hooks/custom_hooks.md)》
2. 《[8.4 Customizing Git - An Example Git-Enforced Policy](http://git-scm.com/book/en/v2/Customizing-Git-An-Example-Git-Enforced-Policy)》

步骤：

1. 在gitlab服务器的上

    ```
    su - git
    cd /home/git/repositories/${username}/${repoName}.git
    mkdir custom_hooks
    cd custom_hooks
    touch update
    chomd 755 update
    ```

2. 上一步新建文件 update 的内容如下：

    ```rb
    #!/usr/bin/env ruby

    $ref_name = ARGV[0]
    $old_value = ARGV[1]
    $new_value = ARGV[2]
    $repo_path = Dir.pwd
     
    def checkParentCount
        lastCommitParentCount = `git cat-file commit #{$new_value} |sed -n -r -e '/^parent [a-z0-9]{40}$/p'|wc -l`
        if lastCommitParentCount.to_i > 1
           $stderr.puts "请先rebase之后再push"
           exit 1
        end
    end

    checkParentCount
    ```

