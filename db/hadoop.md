
# 参考

- [hadoop](http://hadoop.apache.org/docs/r2.9.0/)


# test

```bash
# 解压后
wget http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz
tar zxvf hadoop-2.9.0.tar.gz
cd hadoop-2.9.0

# Running the MiniCluster
P=`pwd`
RM_PORT=10010
JHS_PORT=10020

# 查看帮助
HADOOP_CLASSPATH=${P}/share/hadoop/yarn/test/hadoop-yarn-server-tests-2.9.0-tests.jar \
    bin/hadoop \
    jar \
    ${P}/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.9.0-tests.jar \
    minicluster \
    --help
    
# 运行    
HADOOP_CLASSPATH=${P}/share/hadoop/yarn/test/hadoop-yarn-server-tests-2.9.0-tests.jar \
    bin/hadoop \
    jar \
    ${P}/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.9.0-tests.jar \
    minicluster \
    -rmport ${RM_PORT} \
    -jhsport ${JHS_PORT}
```
