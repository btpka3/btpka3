

## 名词解释 
- JMC：Java Mission Control
- JFR：Java Flight Recorder


## 启用步骤


```bash
# 1. JVM 参数中追加以下配置
-XX:+UnlockCommercialFeatures -XX:+FlightRecorder 

# 2. 启动 jfr
jcmd $PID JFR.start name=abc,duration=120s

# 3. dump jfr
jcmd $PID JFR.dump name=abc,duration=120s filename=abc.jfr

# 4. 检查 jfr 状态
jcmd $PID JFR.check name=abc,duration=120s

# 5. 停止 jfr
jcmd $PID JFR.stop name=abc,duration=120s

# 6. 通过 jmc 分析 dump 出来的 jfr 文件
```
