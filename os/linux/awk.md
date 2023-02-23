

- [The GNU Awk User’s Guide](https://www.gnu.org/s/gawk/manual/gawk.html)
- [Awk to read file as a whole](https://stackoverflow.com/questions/43250592/awk-to-read-file-as-a-whole)

awk 有不同的实现，如果下面示例不可用，请尝试使用 gawk （GNU版本的）

```bash
# 字符串拼接
echo aaa | awk -v x=x1 '{ v="11" $x "22"; print v }'

ll | awk '{print $5}'

awk -F"|" '{print $5}'

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
cat <<EOF |
"AAA Handler" Id=11 RUNNABLE
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.waitForReferencePendingList(Native Method)
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.processPendingReferences(Reference.java:241)

        Number of locked synchronizers = 1
        - java.util.concurrent.ThreadPoolExecutor$Worker@534c8c29

"Common-Cleaner" Id=21 TIMED_WAITING on java.lang.ref.ReferenceQueue$Lock@578b0d8a
        at java.base@11.0.15.14-JDK/java.lang.Object.wait(Native Method)
        -  waiting on java.lang.ref.ReferenceQueue$Lock@578b0d8a
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

"Common-Cleaner" Id=22 TIMED_WAITING on java.lang.ref.ReferenceQueue$Lock@578b0d8a
        at java.base@11.0.15.14-JDK/java.lang.Object.wait(Native Method)
        -  waiting on java.lang.ref.ReferenceQueue$Lock@578b0d8a
        at java.base@11.0.15.14-JDK/java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:155)

"AAA Handler" Id=14 RUNNABLE
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.waitForReferencePendingList(Native Method)
        at java.base@11.0.15.14-JDK/java.lang.ref.Reference.processPendingReferences(Reference.java:241)

        Number of locked synchronizers = 1
        - java.util.concurrent.ThreadPoolExecutor$Worker@534c8c29
EOF
gawk -v threadId=11 '
{
   s=$0
   print ("id=" threadId ", ")
   regex = "(\"[^\"]*\" Id=" threadId " RUNNABLE\n[^\"]*(\n\n|$))"
   print regex
   while(match(s, regex, arr)){
      print "====================" ;
      print arr[1];
      s = substr(s, arr[1, "start"] + arr[1, "length"]);
   }
}
' RS='^$'
```
