### ����ES
`./elasticsearch -d`
`-d`��ʾdaemon

###������������
`curl -XGET 172.16.1.248:9200/default/_search?pretty&q=*`

### ����analyze
`curl -XGET 172.16.1.248:9200/default/_analyze?analyzer=standard&pretty=true&text=���ݶ�ջ�Ƽ����޹�˾`

### ��װICU�������utf
`plugin -install elasticsearch/elasticsearch-analysis-icu/$VERSION`
$VERSION������ https://github.com/elastic/elasticsearch-analysis-icu �в鿴����Ҫ����ES�������������п��Կ������ص���analysis-icu��
������������Էִʽ��
`curl -XGET 172.16.1.248:9200/default/_analyze?tokenizer=icu_tokenizer&pretty=true&text=���Ѽ���`

[�ٷ��ĵ�](https://www.elastic.co/guide/en/elasticsearch/guide/current/icu-plugin.html)

### �ر�ES
`curl -XPOST http://172.16.1.248:9200/_shutdown`