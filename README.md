Zabbix 用 CloudWatch metrics 取得
=================================

## 使い方

* ZABBIX サーバ側に設置する

```
cd /path/to/zabbix/externalscripts
git clone https://github.com/moobay9/zabbix-cloudwatch-php.git
```

* config.php を作る

```
vi /path/to/zabbix/externalscripts/zabbix-cloudwatch-php/config.php
<?php  
$config = array(  
    'AWS_KEY'    => 'XXXXXXXXXXXXXXXXXXXX',  
    'AWS_SECRET' => 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY/ZZZZZZZZ',  
    'REGION'     => 'ap-northeast-1',  
);  
```

* 使い方 

例) zabbix-cloudwatch-php/cloudwatch -n 'AWS/RDS' -m CPUUtilization -d DBInstanceIdentifier -v 'levis-club-rds' -p 300 -s Average
