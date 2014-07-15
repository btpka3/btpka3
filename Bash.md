## number calc
```sh
let a=1+2  # a=3
expr 1 + 2 # 3, 注意，需要使用空格分隔
```
## exit code
```sh
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
```sh
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

```

## 检查目录是否为空
参考：[1](http://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/)
```sh
[ "$(/bin/ls -A yourDir)" ] && echo "Not Empty" || echo Empty`
```

## sed 替换properties中的属性值
参考：
[1](http://en.wikipedia.org/wiki/Regular_expression)、
[2](http://www.mikeplate.com/2012/05/09/extract-regular-expression-group-match-using-grep-or-sed/)、
[3](http://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html)、
[4](http://www.gnu.org/software/sed/manual/html_node/Escapes.html#Escapes)、
[5](http://docs.oracle.com/javase/1.4.2/docs/api/java/util/regex/Pattern.html)

```sh
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
### substr
```sh
str='CREATE TABLE `offercalc_fields` ('
echo $str | grep -Po '(?<=CREATE TABLE `).+(?=`)'
echo $str | sed -nr 's/CREATE TABLE `(.+)`.*/\1/p'
```

### replace
```sh
str=my-app-2.0.2.war
echo $str | sed -nr 's/-([0-9]+\.)+[0-9]+//p'
```

### insert
```sh
str=my-app-2.0.2.war
dateStr=$(date +%Y%m%d%H%M%S)
echo $str | sed -nr "s/(.*)(\.war)/\1-${dateStr}\2/p"
```

### 指定行的内容
```sh
str="a\nb\nc\nd\ne"
echo -e $str | sed -n '1p'    # 打印第1行
echo -e $str | sed -n '2,3p'  # 打印第2~3行
echo -e $str | sed -n '$p'    # 打印第最后一行

tail -f xxxFile
tailf xxxFile | grep --line-buffered --color=auto xxxKeyWord 
```

## date
```sh
dateStr1="$(stat -c %y z.sh)"
dateStr2=$(date -d "${dateStr1}" +%Y%m%d%H%M%S)
echo -e "dateStr1=$dateStr1\ndateStr2=$dateStr2"

# 循环打印当前时间
while true; do sleep 1; echo -n -e "\r`date "+%y-%m-%d %H:%M:%S"`" ; done;
```

## function
```sh
myFunc(){
  echo hello $1
  exit 1
}
funcResult=$(myFunc zhang3)
```

## 压缩包
### zip
```sh
  zip -r file.zip file1 file2 ...
  tar -cvf file.tar file1 file2 ...
  tar -czvf file.tar.gz file1 file2 ...
  tar -cjvf file.tar.bz2 file1 file2 ...
```
### add
```sh
  zip -r file.zip file1 file2 ...
  tar -rf file.tar file1 file2 ...
```
### update
```sh
  zip -r file.zip file1 file2 ...
  #tar -uf file.tar file1 file2 ...
  tar -rf file.tar file1 file2 ...
```
### delete
```sh
  zip -d file.zip file1 file2 ...
  tar -f file.tar --delete file1 file2 ...
```
### list
```sh
  unzip -Z -1 file.zip
  zipinfo -1 file.zip
  tar -tf file.tar | sort | uniq
  tar -tzf file.tar.gz
  tar -tjf file.tar.bz2
```
### unzip 
#### list all
```sh
  unzip file.zip -d outputDir
  tar -xvf file.tar -C outpuDir # outputDir 必须先创建
  tar -xzvf file.tar.gz -C outpuDir # outputDir 必须先创建
  tar -xjvf file.tar.bz2 -C outputIdr # outputDir 必须先创建
```
#### list specific file/dir
```sh
  unzip file.zip entry/path/to/dir/* 
  unzip file.zip entry/path/to/file
  unzip -p file.zip entry/path/to/file > newFile
```

### File Search
```sh
  which someExecutableFile # 从环境变量下查找可执行的文件位置

  # 遍历磁盘，按指定规则查找文件
  find / -name xxx 2>/dev/null
  find / -name "*xxx*" | xargs ls -l

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

### File Content Search

```sh
grep -r -n --include "*.java" systemProperties
```





# PostgreSql backup cron job
```sh
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
~

```

## 当前目录

```sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
```

## awk


```sh
# <td><a href="AAA.tar.bz2">AAA.tar.bz2</a></td>
curl -s http://xxx/ | awk 'match($0, /<td><a.*>(.*)<\/a>.*<\/td>/,arr) {print arr[1]}'
# output : AAA.tar.bz2
```

## 免密码以root权限执行脚本
### 使用SetUID特性

```sh
vi xxx.sh
sudo chown root.root xxx.sh
sudo chmod 4755 xxx.sh
# 这样一来，只有root可以修改该脚本，但任何人都可以以脚本所有者——root的身份执行。
```

### 使用sudo

```sh
vi /etc/sudoers

Cmnd_Alias        CMDS = /path/to/your/script
<username>  ALL=NOPASSWD: CMDS
```