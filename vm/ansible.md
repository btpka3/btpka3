- [Ansible中文权威指南](http://www.ansible.com.cn/)
- [ansible](https://www.ansible.com/)
- [Ansible的简介及部署](https://blog.csdn.net/qq_36023219/article/details/105763094)
- [ansible-examples](https://github.com/ansible/ansible-examples)
- [fcos-k8s](https://github.com/pvamos/fcos-k8s/blob/main/ansible/roles/kubeadm-init/tasks/main.yaml)
- kubernetes 文档中提到的一种安装方式是通过 [kubespray](https://github.com/kubernetes-sigs/kubespray) 安装，
 而 kubespray 是使用了 ansible-playbook 来进行相应的安装工作。

- 命令
    - ansible
    - ansible-playbook
    - ansible-pull


# MacOS 安装

## MacOS 安装
```shell
brew install ansible

https://stackoverflow.com/a/32258393/533317
curl -L https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb > sshpass.rb && brew install sshpass.rb && rm sshpass.rb
```


## MacOS的配置文件

- `$ANSIBLE_CONFIG`
- 当前目录的 `ansible.cfg`
- `~/.ansible.cfg`           # 用户主目录
- `/etc/ansible/ansible.cfg` # MacOS 用 homebrew 安装后， /etc/ansible 需要手动创建。

 
默认的 inventory 配置文件是 /etc/ansible/hosts  但可以通过 ansible.cfg 修改路径
也可以在命令中 通过 `-i` 参数明确指定。


```shell
mkdir ~/.ansible
touch ~/.ansible/.ansible.cfg
touch ~/.ansible/hosts

ln -s ~/.ansible/.ansible.cfg ~/.ansible.cfg

vi ~/.ansible.cfg
# 增加下面两行配置
[defaults]
inventory = /Users/zll/.ansible/hosts

vi ~/.ansible/hosts
# 增加下面一行配置
192.168.56.3   ansible_ssh_user=dangqian.zll
```
## MacOS 验证
```shell
# 常用命令格式：ansible <分组名主机名pattern> -m <模块名> -a '参数1 参数2'

# 列出所有的主机
ansible all --list-hosts

ansible all -m ping   
192.168.56.3 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

ansible k8s_daily -m command -a 'hostname -f'
11.161.107.89 | CHANGED | rc=0 >>
green-console011161107089.na610
11.161.104.35 | CHANGED | rc=0 >>
green-console011161104035.na610
11.164.234.212 | CHANGED | rc=0 >>
green-console011164234212.na610
11.164.234.51 | CHANGED | rc=0 >>
green-console011164234051.na610
```



# module 
- https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html
- https://github.com/ansible/ansible/tree/devel/lib/ansible/modules


# playbook 
playbook 是 ansible的 配置，部署，编排语言。

示例参考  [fcos-k8s](https://github.com/pvamos/fcos-k8s/blob/main/ansible/roles/kubeadm-init/tasks/main.yaml)  
的文件 `ansible/fcos-k8s.yaml`


```shell
# 以10个并发来应用指定的 playbook
ansible-playbook -f 10 playbook.yml 
```


# role

用于将要重复执行的任务分割成多个小的配置文件，然后再按需灵活组合后使用。

示例参考  [fcos-k8s](https://github.com/pvamos/fcos-k8s/blob/main/ansible/roles/kubeadm-init/tasks/main.yaml)  
的文件 `ansible/roles/*/tasks/main.yaml`


# sudo / su
```shell
# FIXME : not work
ansible secops_k8s_2_host -m command -a 'whoami' --ask-pass -b --become-user=admin --ask-become-pass
```