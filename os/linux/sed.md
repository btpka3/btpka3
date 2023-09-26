
- [sed, a stream editor](https://www.gnu.org/software/sed/manual/sed.html)
- [Command Summary for sed](https://docstore.mik.ua/orelly/unix/sedawk/appa_03.htm)



# 字符串替换

```shell
cat <<EOF |
#1catalina.org.apache.juli.AsyncFileHandler.directory = \${catalina.base}/logs
#2localhost.org.apache.juli.AsyncFileHandler.directory = \${catalina.base}/logs
EOF
sed -i 's/\${catalina.base}\/logs/\${catalina.logs}/g' logging.properties

sed -i 's/\${catalina.base}\/logs/\${catalina.logs}/g' logging.properties
# mysql ddl 全局重置 AUTO_INCREMENT 为 1
# 如果MacOS 上执行sed, -i 后面需要增加 `''` 参数
sed -i '' 's/ AUTO_INCREMENT=[0-9]* / AUTO_INCREMENT=1 /g'  ddl.sql
```