需要使用 [Grails quartz](http://grails.org/plugin/quartz)插件。

# 示例

```groovy
class XxxJob {

    static triggers = {
        cron name: 'xxxJobTrigger', startDelay: 60 * 1000, cronExpression: '0 0 */1 * * ?'
    }
    def description = "Xxx任务"

    def yyyService

    def execute(context) {
        try {
            log.info("${description} - 开始")
            doExecute()
            log.info("${description} - 结束")
        } catch (Exception e) {
            log.error("${description} - 异常终止")
        }

    }

    def doExecute(){
        // ...
    }
}
```

# 自测

TestController.groovy

```groovy
// 测试后请删除
class TestController {
    def test() {
        TestJob.triggerNow([foo:"It Works!"])
        render "OK."
    }
}
```




