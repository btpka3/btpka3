

- [The GNU Awk User’s Guide](https://www.gnu.org/s/gawk/manual/gawk.html)
- [Awk to read file as a whole](https://stackoverflow.com/questions/43250592/awk-to-read-file-as-a-whole)

awk 有不同的实现，如果下面示例不可用，请尝试使用 gawk （GNU版本的）




```bash
# MacOS 上这样安装
brew install gawk

# 字符串拼接
echo aaa | awk -v x=xxx '{ v="11" $0 "22" x "33"; print v }'

ll | awk '{print $5}'

awk -F"|" '{print $5}'

# 添加前缀

cat << EOF | awk -v prefix=xxx. '$0=prefix $0'  
aaa
bbb
ccc
EOF

# 输出最后一个field
awk -F" " '{print $NF}'

# 替换换行符 "\r\n" -> "\n"
awk 'BEGIN{RS="\r\n"; ORS="\n"}{print $0}' file > file

# 行内求和
echo 1 1 2 300 | awk '{sum=0;i=1; while(i<5){ sum+=$i; i++} avg=sum/4; print "avg/sum = ",avg,sum}'

# 多行求和
ll | awk '{s+=$5} END{print s}'

# 条件过滤
ll | awk '{ if($5>10000) print $0}'

echo "aaa bbb" | gawk '{
  if(match($0, /(.*) (.*)/, arr)){
     print arr[1] "=" arr[2]
  }
}'

# 正则提取分组
echo '"Common Cleaner" Id=21 BLOCKED on AAA@111 owned by "AAA Handler" Id=11' |
gawk '
{
    if(match($0, /^"[^"]*" [^ ]+ \w+ on ([^ ]+) owned by "[^"]*" Id=([^ ]+)$/, arr)){
        print arr[2] " " arr[1]
    }
}
'

# 作为引号中的命令
echo 'ls -l | awk -F"|" '"'"'{ if($5>10000) print $0}'"'"

# group，count
cat << EOF | awk -F, '{array[$1]++} END{for(k in array){print k,array[k] | "sort -k1"}}'
Item1,200
Item1,200
Item3,900
Item2,500
Item2,800
Item1,600
Item4,
Item5,
Item4,100
Item5,
Item5,444
EOF


# group，distinct concat
cat << EOF |
X1,AAA,101
X2,AAA,102
X2,AAA,102
X3,CCC,301
X4,BBB,201
X5,BBB,202
X6,AAA,103
EOF
awk -F, '{print $2, $3}' | sort | uniq |
awk '
{
    if(array[$1] == "") {
        array[$1] = $2 ;
    } else {
        array[$1] = array[$1] "," $2
    }
}
END {
    for( k in array ){
     print k " " array[k]
    }
}
' | sort

```


### 行内统计

```bash
# 统计行内 数值字符串 是个数，并输出

cat <<EOF |
aa 11 bb
bb
33 ee ff 88
cc 99 00 66 dd
EOF
awk '
{
    delete numArr;
    numArrStr = "" ;
    numberCount=0
    s=$0
    while (match(s, /([[:digit:]]+)/, sArr)) {
        numberCount++ ;
        numArr[numberCount]=sArr[1];

        s=substr(s, sArr[1, "start"]+sArr[1, "length"]);
    }
    for(i in numArr){
        if( i==1){
            numArrStr = numArr[i];
        } else {
            numArrStr = numArrStr "," numArr[i]
        }
    }
    printf "%-30s : %2d : %s \n", $0 , numberCount, numArrStr;
}
'
```


### 提取字符串

[Using Bracket Expressions](https://www.gnu.org/software/gawk/manual/html_node/Bracket-Expressions.html#Bracket-Expressions)

```bash
cat <<EOF |
中华1A18912XDFUDTTSLVP48EC人民
  1A18927UAEB74UQOOW0AUD
22 1A18912XDFUDTTSLVP48EC 1A18912YD4KDTTN4NEHKZ
O ddd
EOF
awk --re-interval '
{
    s=$0
    while(match(s, /([A-Z0-9]{22})/, sArr)) {
        printf "%s\n", sArr[1];
        s=substr(s, sArr[1, "start"]+sArr[1, "length"]);
    }
}
'
```


### 截取

```bash

cat <<EOF |
2020-03-20 14:48:41,166 [http-bio-7001-exec-15] WARN  c.a.s.t.a.c.a.UserDetailServiceImpl - user not found : 111
2020-03-20 14:50:14,165 [http-bio-7001-exec-19] WARN  c.a.s.t.a.c.a.UserDetailServiceImpl - user not found : 222
2020-03-20 14:51:48,487 [http-bio-7001-exec-4] WARN  c.a.s.t.a.c.a.UserDetailServiceImpl - user not found : 222
2020-03-20 14:53:22,138 [http-bio-7001-exec-61] WARN  c.a.s.t.a.c.a.UserDetailServiceImpl - user not found : 333
EOF
awk 'match($0, /.*user not found : (.*)/, arr) {print arr[1]}' | sort | uniq
```


### 替换
替换前N行中满足条件的数据

```bash
cat <<EOF |
   <groupId>aa.bb.cc</groupId>
   <version>1.1.1</version>
   <properties>
      <slf4j.version>1.7.2<slf4j.version>
      <version>2.2.2</version>
   </properties>
EOF
awk -v newVersion=3.3.3  '
{
    if(FNR<4){
      gsub("<version>.*</version>", ("<version>" newVersion "</version>"))
    }
    print
}
'
```

### trim

```shell
echo  "Main-Class: org.springframework.boot   .loader.JarLauncher " | awk -F':' '{gsub(/[ \t\n]+/, "", $2); print "==" $2 "=="}'
```

### 替换-多行

```bash
cat <<EOF |
<project>
  <parent>
    <groupId>aa.bb.cc</groupId>
<<<<<<< HEAD
    <version>0.7.87-changletest-SNAPSHOT</version>
=======
    <version>0.7.81-SNAPSHOT</version>
>>>>>>> 34b96fa2474550722791e84d3749dbf6f50504db
    <relativePath>../pom.xml</relativePath>
  </parent>
  <artifactId>xxx-api</artifactId>
  <properties>
    <slf4j.version>1.7.2<slf4j.version>
    <version>2.2.2</version>
  </properties>
</project>
EOF
gawk -v newVersion=3.3.3  '
{
    print gensub("<<<<<<< .{1,40}\n(\\s*)<version>[^<>]*</version>\n=======\n\\s*<version>[^<>]*</version>\n>>>>>>> .{1,40}\n", "\\1<version>" newVersion "</version>\n", "g")

}
' RS='^$'
```




### 查找-多行

```bash
CONTENT='
"AAA Handler" Id=11 RUNNABLE
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.waitForReferencePendingList(Native Method)
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.processPendingReferences(Reference.java:241)

        Number of locked synchronizers = 1
        - java.util.concurrent.ThreadPoolExecutor$Worker@534c8c29

"Common-Cleaner" Id=21 BLOCKED on AAA@111 owned by "AAA Handler" Id=11
        at java.base@11.0.15.14-JDK/java.lang.Object.wait(Native Method)
        -  waiting on AAA@111
        at java.base@11.0.15.14-JDK/java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:155)

"AAA Handler" Id=12 RUNNABLE
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.waitForReferencePendingList(Native Method)
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.processPendingReferences(Reference.java:241)

        Number of locked synchronizers = 1
        - java.util.concurrent.ThreadPoolExecutor$Worker@534c8c29

"AAA Handler" Id=13 RUNNABLE
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.waitForReferencePendingList(Native Method)
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.processPendingReferences(Reference.java:241)

        Number of locked synchronizers = 1
        - java.util.concurrent.ThreadPoolExecutor$Worker@534c8c29

"Common-Cleaner" Id=22 BLOCKED on AAA@222 owned by "AAA Handler" Id=11
        at java.base@11.0.15.14-JDK/java.lang.Object.wait(Native Method)
        -  waiting on AAA@222
        at java.base@11.0.15.14-JDK/java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:155)

"Common-Cleaner" Id=23 BLOCKED on BBB@111 owned by "AAA Handler" Id=14
        at java.base@11.0.15.14-JDK/java.lang.Object.wait(Native Method)
        -  waiting on BBB@111
        at java.base@11.0.15.14-JDK/java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:155)

"Common-Cleaner" Id=24 BLOCKED on BBB@111 owned by "AAA Handler" Id=14
        at java.base@11.0.15.14-JDK/java.lang.Object.wait(Native Method)
        -  waiting on BBB@111
        at java.base@11.0.15.14-JDK/java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:155)

"AAA Handler" Id=14 RUNNABLE
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.waitForReferencePendingList(Native Method)
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.processPendingReferences(Reference.java:241)

        Number of locked synchronizers = 1
        - java.util.concurrent.ThreadPoolExecutor$Worker@534c8c29
'
STACK_FILE=/tmp/stack.log.2023-02-03_23:30:40
echo $CONTENT > $STACK_FILE

cat $STACK_FILE | grep BLOCKED | awk '
{
    if(match($0, /^"[^"]*" [^ ]+ \w+ on ([^ ]+) owned by "[^"]*" Id=([^ ]+)$/, arr)){
        lock     = arr[1]
        threadId = arr[2]
        print threadId " " lock
    }
}
' | sort | uniq |
awk '
{
    if(match($0, /(.*) (.*)/, arr)){
        threadId=arr[1]
        lock=arr[2]
        if(array[threadId] == "") {
            array[threadId] = lock ;
        } else {
            array[threadId] = array[threadId] "," lock
        }
    }
}
END {
    for( threadId in array ){
       print threadId " " array[threadId]
    }
}
' |
xargs -I '{}' gawk -v id_lock={} -v hostname=`hostname` -v STACK_FILE=$STACK_FILE '
BEGIN {
    if(match(id_lock, /(.*) (.*)/, arr)){
        threadId=arr[1]
        lock=arr[2]
    }
}
{
   s=$0
   regex = "(\"[^\"]*\" Id=" threadId " RUNNABLE)\n([^\"]*(\n\n|$))"
   while(match(s, regex, arr)){
      print "==================== " hostname ":" STACK_FILE;
      print arr[1] " lock " lock;
      print arr[2];
      s = substr(s, arr[1, "start"] + arr[1, "length"]);
   }
}
' RS='^$' $STACK_FILE
```


```bash
for STACK_FILE in /home/admin/logs/hsf/HSF_JStack.log.2023-02-09_10:38:31
do
    grep BLOCKED $STACK_FILE | awk '
{
    if(match($0, /^"[^"]*" [^ ]+ \w+ on ([^ ]+) owned by "[^"]*" Id=([^ ]+)$/, arr)){
        lock     = arr[1]
        threadId = arr[2]
        print threadId " " lock
    }
}
' | sort | uniq |
awk '
{
    if(match($0, /(.*) (.*)/, arr)){
        threadId=arr[1]
        lock=arr[2]
        if(array[threadId] == "") {
            array[threadId] = lock ;
        } else {
            array[threadId] = array[threadId] "," lock
        }
    }
}
END {
    for( threadId in array ){
       print threadId " " array[threadId]
    }
}
' |
xargs -I '{}' gawk -v id_lock={} -v hostname=`hostname` -v STACK_FILE="${STACK_FILE}" '
BEGIN {
    if(match(id_lock, /(.*) (.*)/, arr)){
        threadId=arr[1]
        lock=arr[2]
    }
}
{
   s=$0
   regex = "(\"[^\"]*\" Id=" threadId " RUNNABLE)\n([^\"]*(\n\n|$))"
   while(match(s, regex, arr)){
      print "==================== " hostname ":" STACK_FILE;
      print arr[1] " lock " lock;
      print arr[2];
      s = substr(s, arr[1, "start"] + arr[1, "length"]);
   }
}
' RS='^$' $STACK_FILE
done
```


```bash
LOG_FILE=HSF_JStack_stat_`date +%Y%m%d%H%M%S`.log

pgm -b -p 20 `armory -leg mtee3.content_sync.prodhost` '
for STACK_FILE in /home/admin/logs/hsf/HSF_JStack.log*
do
    grep BLOCKED $STACK_FILE | awk '"'"'
{
    if(match($0, /^"[^"]*" [^ ]+ \w+ on ([^ ]+) owned by "[^"]*" Id=([^ ]+)$/, arr)){
        lock     = arr[1]
        threadId = arr[2]
        print threadId " " lock
    }
}
'"'"' | sort | uniq |
awk '"'"'
{
    if(match($0, /(.*) (.*)/, arr)){
        threadId=arr[1]
        lock=arr[2]
        if(array[threadId] == "") {
            array[threadId] = lock ;
        } else {
            array[threadId] = array[threadId] "," lock
        }
    }
}
END {
    for( threadId in array ){
       print threadId " " array[threadId]
    }
}
'"'"' |
xargs -I {} gawk -v id_lock={} -v hostname=`hostname` -v STACK_FILE="${STACK_FILE}" '"'"'
BEGIN {
    if(match(id_lock, /(.*) (.*)/, arr)){
        threadId=arr[1]
        lock=arr[2]
    }
}
{
   s=$0
   regex = "(\"[^\"]*\" Id=" threadId " RUNNABLE)\n([^\"]*(\n\n|$))"
   while(match(s, regex, arr)){
      print "==================== " hostname ":" STACK_FILE;
      print arr[1] " lock " lock;
      print arr[2];
      s = substr(s, arr[1, "start"] + arr[1, "length"]);
   }
}
'"'"' RS='"'"'^$'"'"' $STACK_FILE
done
' > $LOG_FILE

zip -r ${LOG_FILE}.zip $LOG_FILE
```
