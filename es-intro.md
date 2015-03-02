# 文档

* 《[The Definitive Guide](http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/index.html)》: 适合初学者
   请先阅读 《[mappings and analysis](http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/mapping-analysis.html)》
* 《[reference](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/index.html)》 : 需要有一定的搜索引擎基础、熟悉分布式系统、熟悉query DSL等。
* [Elasticsearch 中文总结](http://learnes.net/)

* ??? http://donlianli.iteye.com/blog/1924721
* ??? http://blog.csdn.net/laigood/article/details/8733292



# index

## 创建索引

```
curl -XPUT 'http://localhost:9200/myIndex/' -d '{
    "settings" : {
        "index" : {
            // ...
        },
        "analysis" : {                                                  # 配置analysis
            "char_filter" : {
                "myCharFilter" : {                                      # 自定义CharFilter的名称
                    // ...
                }
            },
            "tokenizer" : {
                "myTokenizer" : {                                       # 自定义tokennizer的名称
                    // ...
                }
            },
            "filter" : {
                "myFilter" : {                                          # 自定义TokenFilter的名称
                    // ...
                }
            },
            "analyzer" : {
                "myAnalyzer" : {                                        # 自定义analyzer的名称
                    // ...
                }
            }
        }
    },
    "mappings" : {
        "myType": {
            "properties": {
                "myField": {
                    // ...
                 }
            }
        }
    }
}'
```

## 修改索引的设置

```
curl -XPOST http://localhost:9200/my_index/_close                 # 此后，无法再索引上进行任何读写操作。
curl -XPUT http://localhost:9200/my_index/_settings -d '
{
    "index" : {                                                     # 配置index
        "number_of_replicas" : 4,
        "auto_expand_replicas" : "0-5"
    },
    "analysis" : {                                                  # 配置analysis
        "char_filter" : {
            "myCharFilter" : {                                      # 自定义CharFilter的名称
                "type" : "html_strip",
                "escaped_tags" : ["xxx", "yyy"],
                "read_ahead" : "1024"
            }
        },
        "tokenizer" : {
            "myTokenizer" : {                                       # 自定义tokennizer的名称
                "type" : "standard",
                "stopwords" : ["stop1", "stop2"]
            }
        },
        "filter" : {
            "myFilter" : {                                          # 自定义TokenFilter的名称
                "type" : "keyword",
                "buffer_size" : 512
            }
        },
        "analyzer" : {
            "myAnalyzer" : {                                        # 自定义analyzer的名称
                "type": "custom",
                "char_filter" : ["myCharFilter"],
                "tokenizer" : ["myTokenizer"],
                "filter" : ["standard", "nGram","myFilter"]
            }
        }
    }
}'
curl -XPOST http://localhost:9200/my_index/_open                # 此后，就可以在索引上进行读写操作了。
```

## 创建或修改Mapping

```
curl -XPUT http://localhost:9200/myIndex/_mapping/myType?pretty -d '{
    "myType" : {
        "properties":{
            "name" : {
                "type":"string",
                "index": "analyzed",
                "analyzer": "english"
            }
        }
    }
}'
```

# Analyzer
[analyzer](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-analyzers.html) 由单个 Tokenizer 和 零个或多个 TokenFilter 组成。 tokenizer 之前可能有一个或多个  CharFilter.
你可以任意组合内建的CharFilter、Tokenizer、TokenFilter来创建自定义的 analyzer。

## 验证分词效果

* 验证默认 analyzer

    ```
    curl -XGET "http://localhost:9200/_analyze?analyzer=standard&pretty" -d '杭州徐娜拉电子商务有限公司'
    ```

* 验证各种插件，比如 [elasticsearch-analysis-smartcn](https://github.com/elasticsearch/elasticsearch-analysis-smartcn) 提供的 analyzer

    ```
    cd ${ES_HOME}
    bin/plugin -install elasticsearch/elasticsearch-analysis-smartcn/2.4.2   # 只需要执行一次即可
    curl -XGET "http://localhost:9200/_analyze?analyzer=smartcn&pretty" -d '杭州徐娜拉电子商务有限公司'
    ```

* 验证index下自定义analyzer

    ```
    # 请先参考前面的文档，创建索引，并创建自定义analyzer
    curl -XGET "http://localhost:9200/myIndex/_analyze?analyzer=myAnalyzer&pretty" -d '杭州徐娜拉电子商务有限公司'
    ```

## 默认 analyzer
analyzer注册时提供了逻辑名（别名），可以在 mapping 定义中、某些API中引用这个逻辑名。如果这些地方没有明确指定，会使用默认的。

* `default` 逻辑名 : 设置创建文档索引和搜索时使用的默认 analyzer。
* `default_index` 逻辑名 : 仅设置创建文档索引时使用的默认 analyzer。
* `default_search` 逻辑名 : 仅设置搜索时的默认 analyzer。

|Analyzer   | Tokenizer in use | TokenFilter in use              | settings                        |
|-----------|------------------|---------------------------------|---------------------------------|
|standard   |standard          |standard,lowercase,stop          |stopwords,max_token_length       |
|simple     |lowercase         |                                 |                                 |
|whitespace |whitespace        |                                 |                                 |
|stop       |lowercase         |stop                             |stopwords,stopwords_path         |
|keyword    |                  |                                 |                                 |
|pattern    |                  |                                 |lowercase,pattern,flags,stopwords|
|language*  |                  |                                 |stopwords                        |
|snowball   |standard          |standard,lowercase,stop,snowball |stopwords                        |
|custom    |                  |                                 |lowercase,pattern,flags,stopwords|



# Tokenizer
[tokenizer](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-tokenizers.html)


|tokenizer      |settings                                            |
|---------------|----------------------------------------------------|
|standard       |max_token_length                                    |
|edgeNGram      |min_gram,max_gram,token_chars                       |
|keyword        |buffer_size                                         |
|letter         |                                                    |
|lowercase      |                                                    |
|nGram          |min_gram,max_gram,token_chars                       |
|whitespace     |                                                    |
|pattern        |pattern,flags,group                                 |
|uax_url_email  |max_token_length                                    |
|path_hierarchy |delimiter,replacement,buffer_size,reverse,skip,type |
|classic        |max_token_length                                    |
|thai           |                                                    |

# TokenFilter
TokenFilter 从 tokenizer 获取一个tocken的流，然后对该流进行修改。比如，转为小写，删除停词，插入同义词等。

| TokenFilter | settings | description |
|-------------|----------|----|
|standard     |          |    |
|asciifolding |preserve_original|   |
|length       |min,max          |删除太短或太长的词|
|lowercase    |language         |将词变为小写|
|uppercase    |                 |将词变为大写|
|nGram        |min_gram,max_gram||
|edgeNGram    |min_gram,max_gram,side||
|porter_stem  |||
|shingle      |max_shingle_size, min_shingle_size,output_unigrams,output_unigrams_if_no_shingles, token_separator,filler_token||
|stop          |stopwords,stopwords_path,ignore_case,remove_trailing||
|word_delimiter|...||
|stemmer|||
|stemmer_override|||
|keyword_marker|||
|keyword_repeat|||
|kstem|||
|snowball|||
|phonetic|||
|synonym|||
|dictionary_decompounder|||
|hyphenation_decompounder|||
|reverse|||
|elision|||
|truncate|||
|unique|||
|pattern_capture|||
|pattern_replace|||
|trim|||
|limit|||
|hunspell|||
|common_grams|||
|normalization|||
|cjk_width|||
|cjk_bigram|||
|delimited_payload_filter|||
|keep|||
|keep_types|||
|classic|||
|apostrophe|||

# CharFilter

在将字符串传递给Tokenizer之前，先过滤掉一些特殊词。比如，删除HTML标签，将 `&` 变换为 `and` 。

|type       |description              |
|-----------|-------------------------|
|mapping          |按配置将特定的词替换为另外的词 |
|html_strip       |移除HTML标签               |
|pattern_replace  |按正则表达式进行替换         |

elasticsearch-analysis-icu.




# query

lucene javadoc : [Query](http://lucene.apache.org/core/4_2_0/core/index.html?org/apache/lucene/search/Query.html)


|type|description|
|---|---|
|match|接收文本型、数值型、日期型参数。下面又细分为：bolean,phrase,phrase_prefix|
|multi_match|基于match，但允许指定多个字段，并且指定各个字段的boost值等。|
|bool    |可以设置哪些字段must,must_not,should ... |
|boosting||
|common  |将词语分为两组：重要(低频)、不重要（高频），分别查询后，只对匹配到重要组的文档，按重要和不重要一起打分|
|constant_score |可以包含一个filter或query，并将匹配到的每个文档都返回一个固定的boost|
|dis_max|对每个匹配的文档，使用其子查询中的最高分作为文档的分值|
|filtered|对一个query应用多个filter，筛选出需要的文档。类似与SQL中的WHERE子句|
|fuzzy_like_this,flt|综合了fuzzy查询和morelike查询。可应用于多个字段|
|fuzzy_like_this_field| 同fuzzy_like_this查询，但针对单个字段|
|function_score|可以将query查询出的文档重新修改其分值|
|fuzzy|可以按照edit distance设置查找比较类似的词进行查找。|
|geo_shape|???根据地理坐标，按范围查找？|
|has_child||
|has_parent||
|ids|只挑出特定 _uid 的文档|
|indices|允许多多个index进行查询|
|match_all|查询出所有文档|
|more_like_this,mlt|可对多个字段查询|
|more_like_this_field,mlt_field|同more_like_this，但之针对一个字段|
|nested|允许查询内部的对象/文档|
|prefix|挑选出字段原文是以指定前缀开始的文档|
|query_string|使用查询字符串进行查询，允许有AND、OR等关键词|
|simple_query_string|同query_string，但不会抛错，会舍弃不合法的部分|
|range|可以按照值域选取文档并打分|
|regexp|使用正则表达式来挑选文档并打分|
|span_first||
|span_multi||
|span_near||
|span_not||
|span_or||
|span_term||
|term||
|trems||
|top_children||
|wildcard|允许对原文使用通配符 `*`,`?` 进行查询|
|minimum_should_match||
|template||



# query/filter
一般来说，如果只是存在性（yes/no）查询、精确值查询。 
filter后的结果可以被缓存，而且不需要太多内存。

|type|description|
|----|-----------|
|and |           |
|bool|must,must_not,should|
|exists||
|geo_bounding_box||
|geo_distance||
|geo_distance_range||
|geo_polygon||
|geo_shape||
|geohash_cell||
|has_child||
|has_parent||
|ids||
|indices||
|limit||
|match_all||
|missing||
|nested||
|not||
|or||
|prefix||
|query||
|range||
|regexp||
|script||
|term||
|terms||
|type||
 