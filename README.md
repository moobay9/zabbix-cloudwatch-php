Zabbix 用 CloudWatch metrics 取得
=================================

## 使い方

* ZABBIX サーバ側に設置する

```
cd /path/to/zabbix/externalscripts
git clone https://github.com/moobay9/zabbix-cloudwatch-php.git
mv zabbix-cloudwatch-php/cloudwatch cloudwatch
```

* 使い方 

```
例) cw -n 'AWS/RDS' -m CPUUtilization -d DBInstanceIdentifier -v 'club-rds' -p 300 -s Average
```

  * cloudwatch というファイルは旧バージョン互換のために残している古いファイルです。cw を今後はご利用ください。



* zabbix の登録
ホストのマクロに以下を登録（後ろは自分の API KEY を入れる）  

```
{$AWS_KEY}    => 'XXXXXXXXXXXXXXXXXXXX'
{$AWS_SECRET} => 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY/ZZZZZZZZ'
{$AWS_HOST}   => '<hostname>'
```

* アイテムの登録
タイプは「外部チェック」にする
キーに以下のような雰囲気  


```
cw["-n","rds","-m","DatabaseConnections","-v","{AWS_HOST}","--key","{$AWS_KEY}","--sec","{$AWS_SECRET}"]
```

* 引数
  オプションと記載がないものは必須  
  注意: オプションの値で、" " (空白) を区切り文字として使用することはできません。  
  -sMaximum のように空白なしで埋めてください  



  * -n 下記の中から対象となるサービスを選択する
    * rds/rds_cluster/ec2

  * -m メトリクス名
    * CloudWatch で取得したいメトリクス名を選択する

  * -v ディメンションの識別子
    * インスタンスIDやRDSのIDにあたるもの
    * 例: DBInstanceIdentifier / DBClusterIdentifier / InstanceId

    * [EC2](http://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html)
    * [ELB](http://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/elb-metricscollected.html)
    * [RDS](http://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/rds-metricscollected.html)
    * [CloudFront](http://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/cf-metricscollected.html)
    * [AWS Billing and Cost Management](http://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/billing-metricscollected.html)


  * --key
    * IAM のセキュリティキー

  * --sec
    * IAM のセキュリティーシークレット

  * -s 統計（オプション）
    * 標準では Average になっているが変更可能 [Document](http://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/cloudwatch_concepts.html#Statistic)

  * -p 期間（オプション）
    * デフォルトは300秒

