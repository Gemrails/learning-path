### ����ES
`./elasticsearch -d`
`-d`��ʾdaemon

###������������
`curl -XGET 172.16.1.248:9200/default/_search?pretty&q=*`

### ����analyze
- standard analyzer
`curl -XGET 172.16.1.248:9200/default/_analyze?analyzer=standard&pretty=true&text=���ݶ�ջ�Ƽ����޹�˾`
- icu_tokenizer
`curl -XGET 172.16.1.248:9200/default/_analyze?tokenizer=icu_tokenizer&pretty=true&text=���ݶ�ջ�Ƽ����޹�˾`

localhost:9200/default/_analyze?analyzer=smartcn&pretty=true&text=�ȸ�Ա����ɹ���ʶ�����н��ñ��ܻ���͸��

### ��װICU�������utf
`plugin -install elasticsearch/elasticsearch-analysis-icu/$VERSION`
$VERSION������ https://github.com/elastic/elasticsearch-analysis-icu �в鿴��ĿǰΪ2.7.0 
��Ҫ����ES�������������п��Կ������ص���analysis-icu��
������������Էִʽ��
`curl -XGET 172.16.1.248:9200/default/_analyze?tokenizer=icu_tokenizer&pretty=true&text=���Ѽ���`

[�ٷ��ĵ�](https://www.elastic.co/guide/en/elasticsearch/guide/current/icu-plugin.html)

### �ر�ES
`curl -XPOST http://172.16.1.248:9200/_shutdown`