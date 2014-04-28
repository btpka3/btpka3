
# install

```sh
# root执行以下命令
# 会创建 /usr/local/rvm
curl -sSL https://get.rvm.io | sudo bash -s stable

# logout and login again

# 将使用rvm的用户添加到rvm用户组中
usermod -a -G rvm zll
usermod -a -G rvm git
usermod -a -G rvm root

# 查询已知的可安装组件的版本
rvm list known

# 安装ruby
rvm install ruby-2.1.1
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

????
```sh
#rvm user gemsets
rvm gemset use global
bundle update
#bundle init
bundle install

```