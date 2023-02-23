## grep

```
# 查找出不匹配 "xxx" 和 "yyy" 的内容
grep -v "xxx\|yyy"
find /data0/work/git-repo/github/btpka3/btpka3.github.com -type d \
    | grep -v 'node_modules\|bower_components\|jspm_packages\|target\|/.git\|/.gradle\|/build\|/.idea\|/site-packages' \
    | less
```

## zipgrep

```js

```


## free


《[linux内存监控](http://www.cnblogs.com/xuxinkun/p/5541894.html)》
Mac OSX 上没有 free 命令,类似的可以使用 vm_stat 命令。

```
[root@localhost ~]$ free
             total       used       free        shared    buffers   cached
Mem:     total_mem   used_mem    free_mem   shared_mem    buffer     cache
-/+ buffers/cache:  real_used   real_free
Swap:   total_swap  used_swap   free_swap
```

* mem: 物理内存
* swap: 虚拟内存。即可以把数据存放在硬盘上的数据
* shared: 共享内存。存在在物理内存中。
* buffers: 用于存放要输出到disk（块设备）的数据的
* cached: 存放从disk上读出的数据

|名称       |说明 |
|-----------|-----------------|
|total_mem  |物理内存总量|
|used_mem   |已使用的物理内存量|
|free_mem   |空闲的物理内存量|
|shared_mem |共享内存量|
|buffer     |buffer所占内存量|
|cache      |cache所占内存量|
|real_used  |实际使用的内存量|
|real_free  |实际空闲的内存量|
|total_swap |swap总量|
|used_swap  |已使用的swap|
|free_swap  |空闲的swap|

```
real_used = used_mem - buffer - cache
real_free = free_mem + buffer + cache
total_mem = used_mem + free_mem
```

## dd



```
dd if=/dev/zero of=test.1M.txt bs=1M count=1
```

## group

```bash
# 查看用户隶属于哪些用户组
group <userName>

# 将用户添加到指定的用户组中
usermod -a -G <newGroupName> <userName>

# 修改用户的home路径
usermod -m -d /path/to/new/home/dir userNameHere

```

## array

```bash
# 声明数组，元素之间使用空格分隔
arr=( "aaa" "bbb" "xxx" )

# 显示数组长度
echo ${#arr[@]}         # 3
echo ${#arr[*]}         # 3

# 显示整个数组
echo ${arr[@]}          # aaa bbb xxx
echo ${arr[*]}          # aaa bbb xxx
set | grep arr          # arr=([0]="aaa" [1]="bbb" [2]="xxx")

# 显示单个元素
echo ${arr[0]}          # aaa
echo ${arr[999]}        # (Empty)

# 单个元素重新设值
arr[2]='yyy'
set | grep arr          # arr=([0]="aaa" [1]="bbb" [2]="yyy")

arr[999]='yyz'
set | grep arr          # arr=([0]="aaa" [1]="bbb" [2]="yyy" [999]="yyz")

# 向末尾append新元素
arr+=('zzz')
set | grep arr          # arr=([0]="aaa" [1]="bbb" [2]="yyy" [999]="yyz" [1000]="zzz")

# 删除指定的元素
unset arr[2]
set | grep arr          # arr=([0]="aaa" [1]="bbb" [999]="yyz" [1000]="zzz")

# 清除整个数组
unset arr

# 迭代每个元素
for i in ${arr[@]}
do
    echo ===$i===
done


# 迭代非最后一个元素
for (( i=0; i<${#arr[@]}-1; i++ ));
do
    echo ===${arr[i]}===
done
```


## number calc
```bash
let a=1+2  # a=3
expr 1 + 2 # 3, 注意，需要使用空格分隔
```
## exit code
```bash
. /etc/rc.d/init.d/functions
(( 0 && 1 )) # simulate an error exit code
rc=$?
[[ $errCode -ne 0 ]] && {
   failure
   exit 1
}

. /etc/rc.d/init.d/functions
(( 0 && 1 )) && success || {
  failure
  exit $?
}
```

## loop
```bash
for (( COUNTER=0; COUNTER<=10; COUNTER+=2 )); do
    echo $COUNTER
done

for i in {0..10..2}
do
  echo $i
done

a=10
for i in `eval echo {0..$a..2}`; do echo $i; done

for i in `seq 0 2 10`; do echo $i; done



for i in `ls *.zip`
do
  unzip -d ./font $i
done


```

## 检查目录是否为空
参考：[1](http://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/)
```bash
[ "$(/bin/ls -A yourDir)" ] && echo "Not Empty" || echo Empty`
```

## port

```bash
fuser 16000/tcp             # 需要root用户，查看哪个进程监听了16000端口
chmod +s /usr/sbin/fuser    # 如果想要非root用户也可以执行该命令，则设置 SUID 即可
```

## sed 替换properties中的属性值
参考：
[1](http://en.wikipedia.org/wiki/Regular_expression)、
[2](http://www.mikeplate.com/2012/05/09/extract-regular-expression-group-match-using-grep-or-sed/)、
[3](http://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html)、
[4](http://www.gnu.org/software/sed/manual/html_node/Escapes.html#Escapes)、
[5](http://docs.oracle.com/javase/1.4.2/docs/api/java/util/regex/Pattern.html)

```bash
escSedRegKey(){
  # POSIX basic regular expression metacharacter : . [ ] ^ $ ( ) \ * { }
  # POSIX extended regular expression metacharacter : ? + |
  # sed special character: / ( usually as delimiter) &
  echo "$1" | sed -r -e 's/\\/\\\\/g' -e 's/\./\\./g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' -e 's/\^/\\^/g' -e 's/\$/\\$/g' -e 's/\(/\\(/g' -e 's/\)/\\)/g' -e 's/\*/\\*/g' -e 's/\{/\\{/g' -e 's/\}/\\}/g' -e 's/\?/\\?/g' -e 's/\+/\\+/g' -e 's/\|/\\|/g' -e 's/\//\\&/g' -e 's/&/\\\&/g'
}
escSedRegVal(){
  # sed special character: / ( usually as delimiter) &
  echo "$1" | sed -r -e 's/\\/\\\\/g' -e 's/\//\\&/g' -e 's/&/\\\&/g'
}

k='KEY .[]^$()\*{}?+|/&:  KEY= VALUE  .[]^$()\*{}?+|/&:  VALUE '
target='      KEY .[]^$()\*{}?+|/&:  KEY      = xxxxxxx  '

kk=$(echo "$k" | sed -nr 's/[[:space:]]*([^=]*[^[:space:]])[[:space:]]*=.*/\1/p')
kv=$(echo "$k" | sed -nr 's/[^=]*=[[:space:]]*(.*[^[:space:]])[[:space:]]*/\1/p')
ekk=$(escSedRegKey "$kk")
ekv=$(escSedRegVal "$kv")
echo "$target" | sed -r "s/^([[:space:]]*$ekk[[:space:]]*=).*$/\1$ekv/g"
```

## 字符串处理

### 转义

```bash
# 输出单个双引号
echo "\""

# 输出单个单引号
echo "'"

# 输出一串单双引号
echo '"'"'"'"'      # "'"
echo $'"\'"'        # "'"


# 引号内输出 awk
echo 'ls -l | awk -F"|" '"'"'{ if($5>10000) print $0}'"'"
```

### substr

```bash
str='CREATE TABLE `offercalc_fields` ('
echo $str | grep -Po '(?<=CREATE TABLE `).+(?=`)'
echo $str | sed -nr 's/CREATE TABLE `(.+)`.*/\1/p'

# "16000/tcp:           16737"
fuser 16000/tcp 2>&1 | awk '{print $2}'
# sed 的正则表达式请参考：
# https://en.wikipedia.org/wiki/Regular_expression#POSIX_basic_and_extended
fuser 16000/tcp 2>&1 | sed -nr 's/[^[:space:]]+[[:space:]]+([[:digit:]]+)/\1/p'
```

### replace
```bash
str=my-app-2.0.2.war
echo $str | sed -nr 's/-([0-9]+\.)+[0-9]+//p'
```

### insert
```bash
str=my-app-2.0.2.war
dateStr=$(date +%Y%m%d%H%M%S)
echo $str | sed -nr "s/(.*)(\.war)/\1-${dateStr}\2/p"
```

### 指定行的内容
```bash
str="a\nb\nc\nd\ne"
echo -e $str | sed -n '1p'    # 打印第1行
echo -e $str | sed -n '2,3p'  # 打印第2~3行
echo -e $str | sed -n '$p'    # 打印第最后一行

tail -f xxxFile
tailf xxxFile | grep --line-buffered --color=auto xxxKeyWord
```

## 文本处理

```
# append 多行到特定文件
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 aaa
127.0.0.1 bbb
127.0.0.1 ccc
EOF


```

## date
设置时间

```bash
date -s "20150130 10:45:00"
```
循环打印当前时间

```bash
dateStr1="$(stat -c %y z.sh)"
dateStr2=$(date -d "${dateStr1}" +%Y%m%d%H%M%S)
echo -e "dateStr1=$dateStr1\ndateStr2=$dateStr2"

while true; do sleep 1; echo -n -e "\r`date "+%y-%m-%d %H:%M:%S"`" ; done;

# 对命令组进行时间统计
time { ll ; echo aaa ;}
```

## function
```bash
myFunc(){
  echo hello $1
  exit 1
}
funcResult=$(myFunc zhang3)

# -- 迭代参数
aaa(){
    for i in "$@"; do
        echo === $i
    done
}
aaa a1 "a 2" a3
```

## xargs

```bash
# 批量重命名文件后缀
ls *.markdown | xargs -I '{}'  bash -c 'mv {} `basename {} .markdown`.md'

# 批量列出压缩包内容
find . -type f -name "*.jar" | xargs -n 1 unzip -l | less
```

## ls

```basSecurityUtil.trimSqlh
# 按照最后访问时间的先后顺序显示
ll -h --time=atime --full-time -rt core*
    # mtime : 最后修改时间（仅限文件内容）
    # ctime : 最后修改时间（含文件内容和其他元信息——比如权限等）
    # atime : 最后读取时间

# 按照文件大小
ll -S
```

## pipe

```bash
ping baidu.com \
    | while read pong; do echo "$(date): $pong"; done \
    | while read txt; do echo "txt : $txt"; done
```

## ps

```
ps -ax          # 打印所有进程
ps -aux         # 显示内存、cpu使用信息
ps -u  zhang3   # 显示用户 zhang3 所有的进程

ps -ww -fp $PID # 打印完整命令行参数
```

## 压缩包

### split

```bash
# 分割
split -a 2 -b 10m file.tar.gz  newFilePrefix.

# 合并
cat newFilePrefix.* > singleFile
```

### zip
```bash
  zip -r file.zip file1 file2 ...
  tar -cvf file.tar file1 file2 ...
  tar -czvf file.tar.gz file1 file2 ...
  tar -cjvf file.tar.bz2 file1 file2 ...

  # 分割
  tar -czvf - logs/ |split -b 1m - logs.tar.gz.

  # 只解压出其中一个文件
  unzip -j xxx.jar "eventDict.vm" -d .
  zip -d file.zip "to/be/deteted/in/zipfile1" "to/be/deteted/in/zipfile2"
  zip -r file.zip file1 file2 ...
```
### add
```bash
  zip -r file.zip file1 file2 ...
  tar -rf file.tar file1 file2 ...
```
### update
```bash
  zip -r file.zip file1 file2 ...
  #tar -uf file.tar file1 file2 ...
  tar -rf file.tar file1 file2 ...
```
### delete
```bash
  zip -d  file.zip file1 file2 ...
  tar -f file.tar --delete file1 file2 ...
```
### list
```bash
  unzip -Z -1 file.zip
  zipinfo -1 file.zip
  tar -tf file.tar | sort | uniq
  tar -tzf file.tar.gz
  tar -tjf file.tar.bz2
```
### unzip
#### list all
```bash
  unzip file.zip -d outputDir
  unzip -O GBK windows.zip       # 解压在Windows平台上创建的zip
  tar -xvf file.tar       -C outputDir # outputDir 必须先创建
  tar -xzvf file.tar.gz   -C outputDir # outputDir 必须先创建
  tar -xjvf file.tar.bz2  -C outputdir # outputDir 必须先创建
  tar -xJvf file.tar.xz   -C outputdir # outputDir 必须先创建

  rar x xxx.rar /path/to/extract

  # 解压分割的多个文件
  cat newFilePrefix.* | tar -xzvf -C outputDir
```
#### 解压特定的文件

```bash
unzip -j "myarchive.zip" "in/archive/file.txt" -d "/path/to/unzip/to"
```

#### list specific file/dir
```bash
  unzip file.zip entry/path/to/dir/*
  unzip file.zip entry/path/to/file
  unzip -p file.zip entry/path/to/file > newFile
  gunzip -d xxx.gz
```

#### 修改 压缩包中的 entry 路径
```bash
zipnote -w xxx.zip << EOF
@ path/of/old/entry
@=path/of/new/entry
EOF

zipnote -w commons-io-2.6.jar << EOF
@ SymQuickMenu_501.log
@=META-INF/SymQuickMenu_501.log
xxxx dfdfdf dff
@ (comment above this line)
EOF

```




### File Search
```bash
  which someExecutableFile # 从环境变量下查找可执行的文件位置

  # 遍历磁盘，按指定规则查找文件
  find / -name xxx 2>/dev/null
  find / -name "*xxx*" | xargs ls -l
  # 查找 "md" 结尾的文件，并且路径不包含 "node_modules"、"_book"
  find . -type f \
      -not -path "*/node_modules*" \
      -and  -not -path "*/_book/*" \
      -and -name "*.md"

  # 从Linux数据库文件中查找匹配的文件，速度快，但不及时
  #（新建的文件无法立即找到，系统文件数据库一星期个更新一次）
  # 可以通过 updatedb 命令更新系统文件数据库
  whereis fileName
  locate fileName
  locate $PWD/*.sqd        # 列出当前目录及子目录下所有以 sqd 为后缀的文件

  # 统计文件数量
  ls | wc -l

  # 统计当前目录下目录的数量（不含隐藏目录和当前目录本身）
  find $PWD -maxdepth 1 -type d  ! \( -path '*/\.*' -o -path $PWD \)
```

### split
```bash
# 后缀长度2，按行分割，每个文件40000行，源文件 aaa.txt ，前缀 "aaa.txt."
split -a 2 -l 40000 aaa.txt aaa.txt.
```


### File Content Search

```bash
grep -r -n --include "*.java" systemProperties

THE_CLASSPATH=
for i in `ls ./lib/*.jar`
do
  THE_CLASSPATH=${THE_CLASSPATH}:${i}
done
```

# crontab

```
# 默认用户文件路径
/var/spool/cron/$USER_NAME
/var/spool/cron/crontabs/$USER_NAME
/

# 通过命令行追加定时任务
line="* * * * * /path/to/command"
(crontab -u userhere -l; echo "$line" ) | crontab -u userhere -
```

# PostgreSql backup cron job
```bash
[root@s01 ~]# vi /data/srs/util/backDb
#!/bin/bash

################################################## config #########
DB_HOST=192.168.0.000
DB_NAME=website
DB_USER=website
# do not end with '/'
BAK_DIR=/data/back/${DB_NAME}

################################################## backup #########

CUR_PATH=${PWD}
cd ${BAK_DIR}

# delete first if exist
bakFile=`date +%Y-%m-%d`
if [ -d ${bakFile} ]; then
  rm -fr ${bakFile}
fi

# back up today's db data
pg_dump -h ${DB_HOST} -U ${DB_USER} -F d -b -E UTF8 -f ${bakFile} ${DB_NAME}
#mkdir `date +%Y-%m-%d`

################################################## delete old files #########
fw=`date -d '1 weeks ago' +%Y-%m-%d`
for f in *; do

   # delete a week ago backup data file
   if [  "${f}" \< "${fw}"  -o  "${f}" = "${fw}"  ]; then
     rm -fr "${f}"
   fi

done

cd ${CUR_PATH}
```

## 同步多个git仓库

```
#!/bin/bash

DIR=/data0/backup/gitlab/jujn-platform
TIME="date +%Y-%m-%d.%H:%M:%S"


arr=("repo1" "repo2" "repo3")

echo ----------------------------------------------------- `$TIME` 开始同步
for i in ${arr[@]}
do
    cd ${DIR}/${i}
    echo ----------------------------------------------------- `$TIME` ${i}
    git pull --all
done
echo ----------------------------------------------------- `$TIME` 同步结束
```


## 当前目录

```bash
# 仅仅适用于 bash，如果可能，请切换 sh 为 bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR

# 因为 docker 环境中，更多的是使用 sh，而非 bash，所以参考以下
# 参考 ： https://stackoverflow.com/a/1638397/533317
# bash, sh, ksh:
#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

# tcsh, csh:
#!/bin/tcsh
# Absolute path to this script, e.g. /home/user/bin/foo.csh
set SCRIPT=`readlink -f "$0"`
# Absolute path this script is in, thus /home/user/bin
set SCRIPTPATH=`dirname "$SCRIPT"`
echo $SCRIPTPATH
```

## awk


```bash
# <td><a href="AAA.tar.bz2">AAA.tar.bz2</a></td>
curl -s http://xxx/ | awk 'match($0, /<td><a.*>(.*)<\/a>.*<\/td>/,arr) {print arr[1]}'
# output : AAA.tar.bz2

zll@mac-pro 333$ ll
total 24
drwxr-xr-x  2 zll  wheel  68 Sep 26 10:21 a
-rw-r--r--  1 zll  wheel   4 Sep 26 10:21 a.txt
-rw-r--r--  1 zll  wheel   8 Sep 26 10:21 b.txt
-rw-r--r--  1 zll  wheel   2 Sep 26 10:21 c.txt
drwxr-xr-x  2 zll  wheel  68 Sep 26 10:22 x

# 按照特定字段排序
zll@mac-pro 333$ ll | sort -n -r -k 5
drwxr-xr-x  2 zll  wheel  68 Sep 26 10:22 x
drwxr-xr-x  2 zll  wheel  68 Sep 26 10:21 a
-rw-r--r--  1 zll  wheel   8 Sep 26 10:21 b.txt
-rw-r--r--  1 zll  wheel   4 Sep 26 10:21 a.txt
-rw-r--r--  1 zll  wheel   2 Sep 26 10:21 c.txt

cat
a
# 提取特定字段。注意不可使用cut命令——不支持多个空格作为一个分隔符。
zll@mac-pro 333$ ll | awk '{print $5}'

68
4
8
2
68

## 计算文件总大小
ls -l|awk 'BEGIN{sum=0} !/^d/{sum+=$5} END{print "total size is",sum}'


## 行内 sum
echo 1 1 2 300 | awk '{sum=0;i=1; while(i<5){ sum+=$i; i++} avg=sum/4; print "avg/sum = ",avg,sum}'

ll | awk 'BEGIN {s=0} {print $5}'



# 提取特定两个字段，做加法，并排序。
cat <<EOF > /tmp/b
2018-08-06 15:29:00|1|aaa,A,EEE,R_101182,func1,1,0|2,19122
2018-08-06 15:29:00|1|bbb,A,EEE,R_101182,func2,1,0|2,104802838
2018-08-06 15:33:00|1|ccc,A,EEE,R_101182,func3,2,0|1,2893
EOF

cat /tmp/b | awk 'BEGIN{FS="|";avg=0} {split($4, a, ","); print $0 "@" a[2]/a[1]}' | sort -n -r -k 2 -t '@' |grep '@'

```

## 免密码以root权限执行脚本
### 使用SetUID特性

```bash
vi xxx.sh
sudo chown root.root xxx.sh
sudo chmod 4755 xxx.sh
# 这样一来，只有root可以修改该脚本，但任何人都可以以脚本所有者——root的身份执行。

visudo

Cmnd_Alias        CMDS = /path/to/your/script
<username>  ALL=NOPASSWD: CMDS
```


# encoding

```bash
# 以16进制显示文件内容
xxd -p file | tr -d '\n'

################ base64
# 以 base64 显示文件内容
base64 /path/to/file

# base64 解码
echo aGVsbG8gd29ybGR+Cg== |base64 -D

############### JSON

```

# backup

```bash
#!/bin/bash

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TIME="date +%Y-%m-%d.%H:%M:%S"

BAK_DIR=$1
FILE=$2
BACKUP_COUNT=$3

CUR_BAK=$BAK_DIR/`$TIME`

# get existed backups (as Array)
dirList=(`find $BAK_DIR -maxdepth 1 -type d  ! \( -path '*/\.*' -o -path $BAK_DIR \) | sort`)

# delete old backups, only keep the last one
let loopEnd=${#dirList[@]}-$BACKUP_COUNT
for i in `seq 0 $loopEnd`
do
  echo `$TIME` deleteing ${dirList[i]}
  rm -fr ${dirList[i]} 2>&1  || {
    exit $?
  }
done

# bakup a new one
echo `$TIME` creating new backup dir
mkdir $CUR_BAK 2>&1 || {
    rc=$?
    rm -fr ${CUR_BAK} 2>&1
    exit $rc
}

echo `$TIME` backing up $DB_NAME.$T
mv $FILE $CUR_BAK || {
    rc=$?
    rm -fr ${CUR_BAK} 2>&1
    exit $rc
}

echo `$TIME` success.

```
# 多行到文本

```
cat > aaa.txt <<EOF
111
222
333
EOF
```

# echo server

```bash
ncat -l 2000 -k -c 'xargs -n1 echo'
```

# cut

```bash
# 截取 10~20 个字节
cut -b 10-20 xxx.txt
```
# sed

## 大文件中查找并截取上下文

```
# 查找，显示行号，限定最多显示几条
grep -n -m 10 xxx /path/to/largeFile

# 提取特定行之间的内容
sed -n -e '80000,10000p' ~/qh/qh-wap/logs/default.log > stackoverflow.log

# 替换空格
echo 'a b  c' |sed -r 's/ +/_/g' -
```

## 换行符变量

```bash
# https://stackoverflow.com/a/3182519
STR=$'Hello\nWorld'
# 需要双引号
echo "$STR"
```

## 查找并修改配置文件

```bash
# man sshd_config
enableSshdGatewayPorts(){
    file="$1"

    # append if not configured
    EXISTED=`grep -E '^[[:space:]]*GatewayPorts[[:space:]]*(yes|no|clientspecified)[[:space:]]*#*.*$' /tmp/a | wc -l`
    [[ $EXISTED -eq 0 ]] &&  {
        echo GatewayPorts yes >> $file
        return 0
    }

    # update if configured
    [[ $C -ge 1 ]] || {
        sed -i -r "s/^[[:space:]]*GatewayPorts[[:space:]]*(no|clientspecified)[[:space:]]*#*.*$/GatewayPorts yes/g" $file
        return 0
    }
}

cat > /tmp/a <<EOF
xxx
#GatewayPorts no
        GatewayPorts   clientspecified   #xxx
yyy
EOF
enableSshdGatewayPorts /tmp/a # /etc/ssh/sshd_config
cat /tmp/a

cat > /tmp/a <<EOF
xxx
#GatewayPorts no
yyy
EOF

enableSshdGatewayPorts /tmp/a # /etc/ssh/sshd_config
cat /tmp/a
```

# lsof

```bash
# 列出给定PID已删除的文件描述符（FD）
lsof -nP +L1 -p xxxPid
# 清除给定已删除的文件
: > "/proc/$pid/fd/$fd"
```
