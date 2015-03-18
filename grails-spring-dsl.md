## 使用factory方法创建bean

```groovy
import org.apache.curator.framework.CuratorFrameworkFactory
import org.apache.curator.retry.ExponentialBackoffRetry

beans = {
    def cfg = application.config
    // ZooKeeper相关配置
    zkRetry(ExponentialBackoffRetry, 1000, 3)
    zkClient(CuratorFrameworkFactory){bean ->
        bean.factoryMethod = "newClient"
        bean.constructorArgs = [cfg.lizi.zk.connStr, ref('zkRetry')]
        bean.initMethod = 'start'
        bean.destroyMethod = 'close'
    }
}
```

## 分割 resources.groovy

参考 《[More structure for your beans – Grails split resources.groovy](http://blog.klarshift.de/?p=160)》


* 修改 grails-app/conf/spring/resources.groovy

    ```groovy
    beans = {
        // ...
        importBeans("classpath*:spring/*Beans.groovy")   // ResourcePatternResolver#CLASSPATH_ALL_URL_PREFIX
    }
    ```
    
* 修改 scripts/_Events.groovy，使得分割后的文件放置到 classpath下，run-app不会出错

    ```groovy
    eventCompileEnd = { msg ->
        def sourceDir = "${basedir}/grails-app/conf/spring"
        def destination = "${classesDirPath}/spring"

        println "after compile: copying spring beans ... $sourceDir => $destination"

        ant.copy(todir: destination, verbose: true){
            fileset(dir: sourceDir){
                include(name: '*Beans.groovy')
            }
        }
    }
    ```

* 修改 grails-app/conf/BuildConfig.groovy，使得分割后的文件也能打入war包

    ```
    grails.project.work.dir = "target/work"             // Optional
    grails.war.resources = { stagingDir, args ->        // target/work/stage/WEB-INF/classes/spring
        copy(verbose: true, todir: "${stagingDir}/WEB-INF/classes/spring") {    
            fileset(dir: "grails-app/conf/spring") {
                include(name: "*Beans.groovy")
                exclude(name: "resources.groovy")
                exclude(name: "resources.xml")
            }
        }
    }
    ```