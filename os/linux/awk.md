

```bash
ll | awk '{print $5}'

awk -F"|" '{print $5}'

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
cat <<EOF |
aa 11 bb
bb
33 ee ff 88
cc  99 00 66 dd
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
22 1A18912XDFUDTTSLVP48EC 1A18912YD4KDTTN4NEHKZO ddd
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

