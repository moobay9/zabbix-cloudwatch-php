Zabbix 用 CloudWatch metrics 取得
=================================

# 使い方

## config.php を作る


```
<?php  
$config = array(  
    'AWS_KEY'    => 'AKIAIJU7VACX2DLAA34Q',  
    'AWS_SECRET' => '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',  
    'REGION'     => 'ap-northeast-1',  
);  
```


## 引数を設定する

例) php cloudwatch.php -n 'AWS/RDS' -m CPUUtilization -d DBInstanceIdentifier -v 'levis-club-rds' -p 300 -s Average
