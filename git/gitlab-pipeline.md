
# 参考

* [Gitlab pipelines and jobs](https://docs.gitlab.com/ce/ci/pipelines.html#pipeline-graphs)
* [Gitlab runners](https://docs.gitlab.com/ce/ci/runners/README.html)
* [Gitlab install runnres](http://docs.gitlab.com/runner/install/)
* [Gitlab executors](http://docs.gitlab.com/runner/executors/README.html)

# 说明
之前在公司局域网内的本地开发环境都是使用 jenkins 作为持续集成工具(CI)的。
因为现在是将公司项目都放到了 gitlab 上，因为 gitlab pages 的原因开始调查自定义的 gitlab-runner 
——毕竟免费的有时长限制。


# 安装 gitlab-runner

这里推荐使用 docker 来安装。

```bash
docker create                   \
    --name qh-gitlab-runner     \
    --restart always            \
    -v /data0/conf/soft/gitlab-runner/dev.tpl/conf:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock    \
    -v /data0/conf/soft/gitlab-runner/dev.tpl:/data0/conf/soft/gitlab-runner/dev.tpl \
    gitlab/gitlab-runner:latest

docker exec -it qh-gitlab-runner gitlab-runner register
# 因为使用的是 gitlab 的在线代码托管，所以，填写 "https://gitlab.com" 即可。
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
https://gitlab.com

# gitlab-ci token 可以在 你的项目 - Settings - Pipelines 页面看到。
# 可以随便用一个 git 项目里指定，后续可以通过 web 界面为各个项目设置启用/禁用该 runner
Please enter the gitlab-ci token for this runner
xxx

# 随便写，后期可通过 Web 界面修改。
Please enter the gitlab-ci description for this runner
[hostame] my-runner

# 需要预定义好，后期可通过 Web 界面修改。
# 该值用来在 .gitlab-ci.yml 文件中为 yourTask.tags 进行匹配，
# 以便指明该任务需要哪个 gitlab runner 执行。
Please enter the gitlab-ci tags for this runner (comma separated):
my-tag,another-tag

# 如果 .gitlab-ci.yml 文件的任务没有设定 tags，是否允许使用该 runner。
Whether to run untagged jobs [true/false]:
[false]: true

# 使用哪个 executor。
Please enter the executor: ssh, docker+machine, docker-ssh+machine, kubernetes, docker, parallels, virtualbox, docker-ssh, shell:
docker

# 如果 .gitlab-ci.yml 文件中没有指定 docker 镜像，则默认使用哪个。
# docker runner 是通过 /var/run/docker.sock 与 docker 服务通信。 
Please enter the Docker image (eg. ruby:2.1):
alpine:latest
```


如果 通过 gitlab的 Web 画面触发了 pipeline，在可以看到有该 docker 容器在执行。

```bash
zll@mac-pro c$ docker ps
CONTAINER ID  IMAGE         COMMAND                CREATED        STATUS        PORTS  NAMES
f5ceb4317d9f  d735d9d14b55  "gitlab-runner-build"  3 minutes ago  Up 4 seconds         runner-22d385ba-project-3649340-concurrent-0-predefined
```


# FIXME
* gitlab-runner 只需要能访问互联网即可，那它是如何监听 gitlab 上的 push 等事件的？
* gitlab-ci 是如何获取源码的？
* job 如何分发到不同的 gitlab-runner 的？
* 某个 job 的结果文件 是如何缓存、并在不同 job 中共享的？自行猜测（未验证）： 
   
    1. gitlab-runner 环境是必须有安装 git 的。先用 git 在 gitlab-runner 环境（docker 容器）中下载源码。
    1. gitlab-runner 通知 docker 服务下载所需的镜像（比如 node），并将 gitlab-runner docker 容器内下载的源代码 
       通过 docker scp 类似功能 copy 到 目标 docker 容器内。
      
    1. 在 node docker 容器内执行相应的命令，根据 .gitlab-ci.yml 中 cache、key 的相关配置，
       将结果文件 copy 到 gitlab-runner docker 容器指定的缓存目录下。

* 如果 maven/gradle 需要下载大量jar包，甚至还都需要先下载 gradle， 缓存绝对有必要。如何搞？ 




