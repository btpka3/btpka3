
# lsof

```bash
# 列出给定PID已删除的文件描述符（FD）
lsof -nP +L1 -p xxxPid
# 清除给定已删除的文件
: > "/proc/$pid/fd/$fd"


lsof -n -i :8080                               # 获取哪些进程在使用（监听/访问）8080端口
lsof -nP -iTCP -sTCP:LISTEN -a -p 15008        # 获取进程 15008 监听的TCP 端口
lsof -iUDP                                     # 按UDP过滤
```


# 参数

lsof 默认都是将所列的选项进行 OR（或）拼接的。除了 -u , -p, -g, -c, -s 选项值有 ^ （取反）时。

```plain


lsof -a             # AND, 表示两个参数都必须满足时才显示结果
lsof -b             # 避免使用 会Block的 kernel函数，比如：lstat(2), readlink(2), and stat(2).
lsof -c string      # ⭕️显示COMMAND列中包含指定字符的进程所有打开的文件。
                        如果值是 / 开头，且 / 结尾，则认为两个斜杠之间是正则. 注意：结尾的 / 后面可以跟以下修饰符
                        - b : basic regular expression
                        - i : 忽略大小
                        - x : extended regular expression
lsof -c number      # 设置显示的命令名的长度
lsof -u userName    # ⭕️显示所属user(用户loginName或userid) 进程打开的文件

lsof -g gid         # 显示归属gid的进程情况
lsof +d /DIR/       # 显示给定目录下被进程打开的文件
lsof +D /DIR/       # 同上    ，但是会搜索目录下的所有目录，时间相对较长
lsof -d FD          # 显示指定文件描述符的进程， 示例值：
                        ^6,^2
                        cwd,1,3
                        0-7
                        ^0-7
lsof -n             # 不将IP转换为hostname，缺省是不加上-n参数
lsof -P             # ⭕️使用数字型的端口号（比如:8080)，而不是文本型的端口名称（比如：http-alt）
lsof -i             # ⭕️用以显示符合条件的进程情况
lsof -i[46][protocol][@hostname|hostaddr][:service|port]
                    # ⭕️其中 service 是 /etc/services 中定义的名称

lsof -s[p:s]        # ⭕️ 可选值: protocol:state
                      protocol : TCP, UDP
                      示例值
                      lsof -iTCP TCP:LISTEN
                      lsof -iUDP -sUDP:Idle
                      常见的TCP状态： CLOSED, IDLE, BOUND, LISTEN, ESTABLISHED, SYN_SENT,
                                    SYN_RCDV, ESTABLISHED, CLOSE_WAIT, FIN_WAIT1, CLOSING,
                                    LAST_ACK, FIN_WAIT_2, TIME_WAIT
                      常见的UDP状态： Unbound, Idle
```
