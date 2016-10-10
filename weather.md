
参考 [这里](http://openweather.weather.com.cn/Home/Help/Using.html)

## 示例

ZllController.groovy

```groovy
package xyz.kingsilk.qh.wap.controller

import grails.converters.JSON
import org.apache.commons.codec.binary.Base64
import org.apache.commons.codec.digest.HmacUtils
import org.elasticsearch.common.joda.time.DateTime
import org.springframework.http.ResponseEntity
import org.springframework.web.util.UriComponentsBuilder

class ZllController {

    def restTemplate

    def index() {
        render "PK~"
    }

    def aa() {
        render "PK1~  " + Base64.encodeBase64String(HmacUtils.hmacSha1("abc".getBytes("UTF-8"), "12345678".getBytes("UTF-8")));
    }

    def weather() {

        def appId = 'xxxxxxxxxxxx'
        def appId4Param = appId.substring(0, 6)
        def priKey = 'xxx_SmartWeatherAPI_yyyy'

        // 杭州
        def areaId = '101210101'
        def date = DateTime.now().toString("yyyyMMddHHmm", Locale.CHINESE)

        // 准备公钥（appId使用的是完整的值）
        String pubKey = "http://open.weather.com.cn/data/?areaid=${areaId}&type=forecast_f&date=${date}&appid=${appId}".toString()
        String key = Base64.encodeBase64String(HmacUtils.hmacSha1(priKey.getBytes("UTF-8"), pubKey.getBytes("UTF-8")));

        // 准备URL（appId使用的是前6个字符）
        String url = "http://open.weather.com.cn/data/?areaid=${areaId}&type=forecast_f&date=${date}&appid=${appId4Param}".toString()
        URI uri = UriComponentsBuilder.fromHttpUrl(url)
                .queryParam("key", key)
                .build()
                .encode("UTF-8")  // 注意：base64 需要 URLEncoding
                .toUri()

        println "key ==== " + key
        println "Uri ==== " + uri.toString()

        ResponseEntity respEntity = restTemplate.getForEntity(uri, String)

        String respStr = respEntity.getBody()

        if ("data error".equals(respStr)) {
            render "传递参数出错"
        } else {
            println "resp code ==== " + respEntity.getStatusCode()
            println "resp body ==== " + respStr

            def jsonObj = JSON.parse(respStr)

            render(jsonObj)
        }
    }
}

```