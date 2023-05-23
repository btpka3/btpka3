## docer install

[ref](https://www.elastic.co/guide/en/logstash/current/docker.html)

```bash
docker pull docker.elastic.co/logstash/logstash:5.4.0

docker run --rm -it \
    -v ~/settings/:/usr/share/logstash/config/ \
    -v ~/pipeline/:/usr/share/logstash/pipeline/ \
    docker.elastic.co/logstash/logstash:5.4.0

```
