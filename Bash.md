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
  find / -name xxx 2>/dev/null
  find / -name "*xxx*" | xargs ls -l
```