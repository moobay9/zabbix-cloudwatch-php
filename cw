#!/usr/bin/php
<?php
// Include the SDK using the Composer autoloader
require 'zabbix-cloudwatch-php/vendor/autoload.php';
//require 'zabbix-cloudwatch-php/config.php';

$reg = 'ap-northeast-1';

use Aws\CloudWatch\CloudWatchClient;
 
$options = getopt('n:m:v:p::s::', ['key:','sec:', 'tg::']);

$client = new MyCloudWatchClient($options);


switch (true)
{
    case ($options['n'] === 'ec2'):
    case ($options['n'] === 'rds'):
    case ($options['n'] === 'billing'):
    case ($options['n'] === 'rds_cluster'):
    case ($options['n'] === 'alb'):
    case ($options['n'] === 'cf'):
        $client->{$options['n']}();
        break;
}



class MyCloudWatchClient
{
    /**
     * デフォルトリージョン
     */
    public $reg = 'ap-northeast-1';

    /**
     * オプション
     */
    public $options;

    /**
     * 取得用パラメーター
     */
    public $static_param = [];


    public function __construct($options = null)
    {
        // 静的に保存
        $this->options = $options;

        // 初期値設定
        $this->options['p'] = (isset($options['p'])) ? $options['p'] : '300';
        $this->options['s'] = (isset($options['s'])) ? $options['s'] : 'Average';

        $this->static_param = [
            'StartTime'  => strtotime('-'.$this->options['p'].' sec'),
            'EndTime'    => strtotime('now'),
            'Period'     => $this->options['p'],
            'Statistics' => [
                $this->options['s'],
            ],
        ];
    }

    /**
     * EC2
     */
    public function ec2()
    {
        $this->static_param = array_merge($this->static_param, [
            'Namespace'  => 'AWS/EC2',
            'MetricName' => $this->options['m'],
            'Dimensions' => [
                [
                    'Name'   => 'InstanceId',
                    'Value'  => $this->options['v'],
                ],
            ],
        ]);

        $result = $this->_getMetric();
        $this->_putMetric($result);
    }


    /**
     * RDS 単体
     */
    public function rds()
    {
        $this->static_param = array_merge($this->static_param, [
            'Namespace'  => 'AWS/RDS',
            'MetricName' => $this->options['m'],
            'Dimensions' => [
                [
                    'Name'   => 'DBInstanceIdentifier',
                    'Value'  => $this->options['v'],
                ],
            ],
        ]);

        $result = $this->_getMetric();
        $this->_putMetric($result);
    }


    /**
     * RDS CLUSTER
     */
    public function rds_cluster()
    {
        $this->static_param = array_merge($this->static_param, [
            'Namespace'  => 'AWS/RDS',
            'MetricName' => $this->options['m'],
            'Dimensions' => [
                [
                    'Name'   => 'DBClusterIdentifier',
                    'Value'  => $this->options['v'],
                ],
                [
                    'Name'  => 'Role',
                    'Value' => 'WRITER'
                ],
            ],
        ]);

        $result = $this->_getMetric();
        $this->_putMetric($result);
    }


    /**
     * Application LoadBalancer
     */
    public function alb()
    {
        $this->static_param = array_merge($this->static_param, [
            'Namespace'  => 'AWS/ApplicationELB',
            'MetricName' => $this->options['m'],
            'Dimensions' => [
                [
                    'Name'   => 'LoadBalancer',
                    'Value'  => $this->options['v'],
                ],
            ],
        ]);

        $target_group_metrics = [
            'HealthyHostCount',
            'UnHealthyHostCount',
        ];

        if (in_array($this->static_param['MetricName'], $target_group_metrics))
        {
            $this->static_param['Dimensions'][] = [
                'Name'   => 'TargetGroup',
                'Value'  => $this->options['tg'],
            ];
        }

        $result = $this->_getMetric();
        $this->_putMetric($result);
    }


    /**
     * CloudFront
     */
    public function cf()
    {
        $this->static_param = array_merge($this->static_param, [
            'Namespace'  => 'AWS/CloudFront',
            'MetricName' => $this->options['m'],
            'Dimensions' => [
                [
                    'Name'  => 'DistributionId',
                    'Value' => $this->options['v'],
                ],
                [
                    'Name'  => 'Region',
                    'Value' => 'Global',
                ],
            ],
        ]);

        // CFはバージニア北部リージョンにする必要がある
        $this->reg = 'us-east-1';

        $result = $this->_getMetric();
        $this->_putMetric($result);
    }


    /**
     * 請求
     */
    public function billing()
    {
        $this->static_param = array_merge($this->static_param, [
            'Namespace'  => 'AWS/Billing',
            'MetricName' => $this->options['m'],
            'Dimensions' => [
                [
                    'Name'   => 'Currency',
                    'Value'  => $this->options['v'],
                ],
            ],
        ]);

        // 請求はバージニア北部リージョンにする必要がある
        $this->reg = 'us-east-1';

        $result = $this->_getMetric();
        $this->_putMetric($result);
    }

    /**
     * 取得する
     */
    protected function _getMetric()
    {
        $client = CloudWatchClient::factory([
            'key'    => $this->options['key'],
            'secret' => $this->options['sec'],
            'region' => $this->reg,
        ]);

        return $client->getMetricStatistics($this->static_param);
    }

    /**
     *  出力する
     */
    protected function _putMetric($result)
    {
        foreach ($result as $k => $v)
        {
            if($k === 'Datapoints' and isset($v['0']))
            {
                echo $v['0'][$this->options['s']];
            }
        }
    }
}