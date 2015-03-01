请先考虑以下场景的功能该如何实现：

1. 电商网站的搜索，用户想通过汉语拼音（全拼、拼音首字母、或与汉字混合输入）进行商品、品牌、关键词的查找
2. 后台管理人员在搜索商品的时候，希望能只提供一个输入口，可以输入商品汉字名称，拼音名称，或者商品ID来过滤商品。

参考 [字典树 - trie](http://zh.wikipedia.org/zh-cn/Trie)、[N-Gram](http://en.wikipedia.org/wiki/N-gram)、
[《ElasticSearch拼音插件elasticsearch-analysis-pinyin使用介绍》](http://my.oschina.net/xiaohui249/blog/214505)、
《基于Lucene的联系人拼音检索》[第一部分](http://www.cnblogs.com/ibook360/archive/2011/11/30/2269191.html) 、[第二部分](http://www.cnblogs.com/ibook360/archive/2011/11/30/2269202.html)、[第三部分](http://www.cnblogs.com/ibook360/archive/2011/11/30/2269210.html)

而搜索引擎一般索引了海量的文档，可能不可能对所有文档中的语句都处理为完整的trie。一般是先按照用户的拼音混合输入，匹配到最匹配、最热门的搜索关键词，然后再按照标准的搜索关键词进行查询。



# ElasticSearch + 拼音

 整理之后的步骤如下：

```
# clone elasticsearch-rtf，它基于elasticsearch老版本修改而来的一个比较完善的，用于演示用的demo包
# 如果下载速度比较慢的话，可以到[百度网盘](http://pan.baidu.com/s/1pJNkrUV)下载
git clone https://github.com/medcl/elasticsearch-rtf.git
mkdir -p elasticsearch-rtf/plugins/pinyin

# 获取所需的拼音插件
git clone https://github.com/medcl/elasticsearch-analysis-pinyin.git
cd elasticsearch-analysis-pinyin
mvn clean install -Dmaven.test.skip
cp target/elasticsearch-analysis-pinyin-1.2.2.jar  /path/to/elasticsearch-rtf/plugins/pinyin
cp ~/.m2/repository/pinyin4j/pinyin4j/2.5.0/pinyin4j-2.5.0.jar /path/to/elasticsearch-rtf/plugins/pinyin

# 启动 elasticsearch
/path/to/elasticsearch-rtf/bin/elasticsearch

# 删除索引 (第一次不需要)
curl -XDELETE 'http://localhost:9200/adc?pretty'

# 创建索引
curl -XPUT 'http://localhost:9200/adc/' -d '
{
    "index" : {
        "analysis" : {
            "analyzer" : {
                "pinyin_analyzer" : {
                    "tokenizer" : "my_pinyin",
                    "filter" : ["standard"]
                }
            },
            "tokenizer" : {
                "my_pinyin" : {
                    "type" : "pinyin",
                    "first_letter" : "none",
                    "padding_char" : " "
                }
            }
        }
    }
}'

# 检查分词效果 ("浙江省" UTF-8 URL 编码)
curl -XGET "http://localhost:9200/adc/_analyze?text=%E6%B5%99%E6%B1%9F%E7%9C%81&analyzer=pinyin_analyzer&pretty"

# 修改索引参数
curl -XPOST http://localhost:9200/adc/_close
curl -XPUT http://localhost:9200/adc/_settings -d '
{
    "index" : {
        "analysis" : {
            "analyzer" : {
                "pinyin_analyzer" : {
                    "tokenizer" : ["my_pinyin"],
                    "filter" : ["standard", "nGram"]
                }
            },
            "tokenizer" : {
                "my_pinyin" : {
                    "type" : "pinyin",
                    "first_letter" : "prefix",
                    "padding_char" : ""
                }
            }
        }
    }
}'
curl -XPOST http://localhost:9200/adc/_open

# 检查分词效果 ("浙江省" UTF-8 URL 编码)
curl -XGET "http://localhost:9200/adc/_analyze?text=%E6%B5%99%E6%B1%9F%E7%9C%81&analyzer=pinyin_analyzer&pretty"
# 检查分词效果 ("好的" UTF-8 URL 编码)
# FIXME：多音字？
curl -XGET "http://localhost:9200/adc/_analyze?text=%E5%A5%BD%E7%9A%84&analyzer=pinyin_analyzer&pretty"


# 创建mapping （注意数据第一层的key的命名）
curl -XPOST http://localhost:9200/adc/province/_mapping -d'
{
    "province": {
        "properties": {
            "name": {
                "type": "multi_field",
                "fields": {
                    "name": {
                        "type": "string",
                        "store": "no",
                        "term_vector": "with_positions_offsets",
                        "analyzer": "pinyin_analyzer",
                        "boost": 10
                    },
                    "primitive": {
                        "type": "string",
                        "store": "yes",
                        "analyzer": "keyword"
                    }
                }
            }
        }
    }
}'

# 添加文档
curl -XPUT 'localhost:9200/adc/province/1?pretty' -d '
{
  "name": "湖南省"
}'

curl -XPUT 'localhost:9200/adc/province/2?pretty' -d '
{
  "name": "河南省"
}'

curl -XPUT 'localhost:9200/adc/province/3?pretty' -d '
{
  "name": "北京市"
}'

curl -XPUT 'localhost:9200/adc/province/4?pretty' -d '
{
  "name": "上海市"
}'


# 查询
curl -XGET 'http://localhost:9200/adc/province/_search?q=name:shi&pretty'
curl -XGET 'http://localhost:9200/adc/province/_search?q=name:%E7%9C%81&pretty'   # "省" UTF-8的 URL编码
FIXME：汉字的情况下，还是被拆分成了一个个拼音（最小到单个字母）如何避免？
FIXME：如何避免一个字的拼音的非开开头匹配？比如:"省"的拼音是"sheng", 搜索 "eng" 应不能匹配到 "省"。
```


用以下源代码可以看到elasticsearch-analysis-pinyin的部分问题

```java
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.elasticsearch.common.settings.ImmutableSettings;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.index.analysis.PinyinAnalyzer;


/**
 *
 * document : 重阳节 summer
 * testEsAnalysisPinyin mode = prefix, terms = 1 :[zyj zhong yang jie  summer]
 * testEsAnalysisPinyin mode = append, terms = 1 :[zhong yang jie  summer zyj]
 * testEsAnalysisPinyin mode = none, terms = 1 :[zhong yang jie  summer]
 * testEsAnalysisPinyin mode = only, terms = 2 :[zyj, summer]
 */
public class Test {

    static final String str = "重阳节 summer";

    public static void main(String[] args) {
        System.out.println("document : " + str);

        String[] firstLeterModes = new String[] {
                "prefix", "append", "none", "only"
        };

        for (String firstLetterMode : firstLeterModes) {
            testEsAnalysisPinyin(firstLetterMode);
        }
    }

    private static void testEsAnalysisPinyin(String firstLetterMode) {

        Settings settings = ImmutableSettings.settingsBuilder()
                .put("first_letter", firstLetterMode)
                .put("padding_char", " ")
                .build();

        List<String> result = new ArrayList<String>();
        Analyzer analyzer = new PinyinAnalyzer(settings);
        try {
            TokenStream tokenStream = analyzer.tokenStream("field", str);
            CharTermAttribute term = tokenStream.addAttribute(CharTermAttribute.class);
            tokenStream.reset();
            while (tokenStream.incrementToken()) {
                result.add(term.toString());
            }
            tokenStream.end();
            tokenStream.close();
        } catch (IOException e1) {
            e1.printStackTrace();
        }

        System.out.println("testEsAnalysisPinyin mode = " + firstLetterMode
                + ", terms = " + result.size() + " :"
                + result);
    }
}
```


# 自定义实现（未完待续）

elasticsearch-rtf 使用ES版本比较老，而elasticsearch-analysis-pinyin又不提供汉字拼音混合输入，不支持多音字，因此觉得有必要自己拼装一个，如有必要，可以elasticsearch-analysis-pinyin中的代码。

要求示例："杭州市" 的每个汉字可以对应分解为：

|汉字|反向索引的词|
|---|---|
|'杭' | '', '杭', 'h', 'ha', 'han', 'hang' |
|'州' | '', '州', 'z', 'zh', 'zho', 'zhou' |
|'市' | '', '市', 's', 'sh', 'shi' |

如果刨去上述每个字都为空字符串 '' 的情况，总共有 6*6*5-1=179 种情况。


基本思路：

1. 先用smartcn将中英混合字词给去切词。比如："where is 杭州市?" 切词为 "where", "杭州市"。
2. 再对切词中的中文词转换为拼音、汉字的组合。比如："杭州市" 变换为 "杭州市","h州市","hz市","hangzhoushi","hzs","hangzhsh" 等




## 了解 standard analyzer

```

curl -XGET "http://localhost:9200/_analyze?analyzer=standard&pretty" -d 'hang zhou shi'
```

结果如下：

```
{
  "tokens" : [ {
    "token" : "hang",
    "start_offset" : 0,
    "end_offset" : 4,
    "type" : "<ALPHANUM>",
    "position" : 1
  }, {
    "token" : "zhou",
    "start_offset" : 5,
    "end_offset" : 9,
    "type" : "<ALPHANUM>",
    "position" : 2
  }, {
    "token" : "shi",
    "start_offset" : 10,
    "end_offset" : 13,
    "type" : "<ALPHANUM>",
    "position" : 3
  } ]
}
```


## 了解 edgeNGram TokenFilter

```
curl -XDELETE 'localhost:9200/btpka3?pretty'
curl -XPUT http://localhost:9200/btpka3?pretty -d'
{
    "index" : {
        "analysis" : {
            "filter" : {
                "myFilter" : {
                    "type" : "edgeNGram",
                    "min_gram" : "1",
                    "max_gram" : "6"
                }
            },
            "analyzer" : {
                "zllEdgeNGram" : {
                    "tokenizer" : "standard",
                    "filter" : ["myFilter"]
                }
            }
        }
    }
}'
curl -XGET "http://localhost:9200/btpka3/_analyze?analyzer=zllEdgeNGram&pretty" -d 'hang zhou shi'
```

结果如下：

```
{
  "tokens" : [ {
    "token" : "h",
    "start_offset" : 0,
    "end_offset" : 4,
    "type" : "word",
    "position" : 1
  }, {
    "token" : "ha",
    "start_offset" : 0,
    "end_offset" : 4,
    "type" : "word",
    "position" : 1
  }, {
    "token" : "han",
    "start_offset" : 0,
    "end_offset" : 4,
    "type" : "word",
    "position" : 1
  }, {
    "token" : "hang",
    "start_offset" : 0,
    "end_offset" : 4,
    "type" : "word",
    "position" : 1
  }, {
    "token" : "z",
    "start_offset" : 5,
    "end_offset" : 9,
    "type" : "word",
    "position" : 2
  }, {
    "token" : "zh",
    "start_offset" : 5,
    "end_offset" : 9,
    "type" : "word",
    "position" : 2
  }, {
    "token" : "zho",
    "start_offset" : 5,
    "end_offset" : 9,
    "type" : "word",
    "position" : 2
  }, {
    "token" : "zhou",
    "start_offset" : 5,
    "end_offset" : 9,
    "type" : "word",
    "position" : 2
  }, {
    "token" : "s",
    "start_offset" : 10,
    "end_offset" : 13,
    "type" : "word",
    "position" : 3
  }, {
    "token" : "sh",
    "start_offset" : 10,
    "end_offset" : 13,
    "type" : "word",
    "position" : 3
  }, {
    "token" : "shi",
    "start_offset" : 10,
    "end_offset" : 13,
    "type" : "word",
    "position" : 3
  } ]
}
```