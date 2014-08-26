Zabbix 用 CloudWatch metrics 取得
=================================

## 使い方

* config.php を作る


```
<?php  
$config = array(  
    'AWS_KEY'    => 'AKIAIJU7VACX2DLAA34Q',  
    'AWS_SECRET' => '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',  
    'REGION'     => 'ap-northeast-1',  
);  
```

* ZABBIX サーバ側に設置する

```
cd /path/to/zabbix/externalscripts
git clone https://github.com/moobay9/zabbix-cloudwatch-php.git
```

* 使い方 

例) zabbix-cloudwatch-php/cloudwatch -n 'AWS/RDS' -m CPUUtilization -d DBInstanceIdentifier -v 'levis-club-rds' -p 300 -s Average
