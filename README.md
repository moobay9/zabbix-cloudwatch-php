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

例) cloudwatch -n 'AWS/RDS' -m CPUUtilization -d DBInstanceIdentifier -v 'club-rds' -p 300 -s Average

* zabbix の登録
ホストのマクロに以下を登録（後ろは自分の API KEY を入れる）  

```
{$AWS_KEY}    => 'XXXXXXXXXXXXXXXXXXXX'
{$AWS_SECRET} => 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY/ZZZZZZZZ'
{$HOST} => '<hostname>'
```

* アイテムの登録
タイプは「外部チェック」にする
キーに以下のような雰囲気  


```
cloudwatch["-n","AWS/RDS","-m","DatabaseConnections","-d","DBInstanceIdentifier","-v","{HOST.NAME}","-s","Average","-p","300","--key","{$AWS_KEY}","--sec","{$AWS_SECRET}"]
```
