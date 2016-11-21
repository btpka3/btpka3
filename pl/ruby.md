
# install

```bash
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# root执行以下命令
# 会创建 /usr/local/rvm
curl -sSL https://get.rvm.io | bash -s stable

# logout and login again

# 将使用rvm的用户添加到rvm用户组中
#sudo usermod -a -G rvm git
#sudo usermod -a -G rvm root
sudo usermod -a -G rvm `whoami`

# 查询已知的可安装组件的版本
rvm list known

# 安装ruby
rvm install ruby-2.2.1
rvm alias create default 2.1.1
gem install bundler --no-ri --no-rdoc
which ruby
ruby -v

# 为需要使用rvm的账户执行以下命令
su - git
echo "rvm use 2.1.1" > /home/git/gitlab/.rvmrc
cd /home/git/gitlab/
ruby -v

bundle install --deployment --without development test mysql aws
exit

# 删除rvm
sudo rm -fr ~/.rvm
sudo rm -fr ~/.rvmrc
sduo rm -fr /usr/local/rvm
sduo rm -fr /etc/profile.d/rvm.sh

```

# 更换 gem 源

```
gem sources -l
gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/
gem sources -l

bundle config mirror.https://rubygems.org https://ruby.taobao.org
```

????
```bash
#rvm user gemsets
rvm gemset use global
bundle update
#bundle init
bundle install
/usr/local/rvm/scripts/rvm
```

# 卸载 rvm
```
rvm implode
```