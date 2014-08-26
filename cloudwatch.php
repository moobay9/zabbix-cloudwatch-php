<?php
// Include the SDK using the Composer autoloader
require 'vendor/autoload.php';
require 'config.php';
 
use Aws\CloudWatch\CloudWatchClient;
 
$client = CloudWatchClient::factory(array(
        'key'    => $config['AWS_KEY'],
        'secret' => $config['AWS_SECRET'],
        'region' => $config['REGION'],
));

$options = getopt('n:m:d:v:p:s:');

$result = $client->getMetricStatistics(array(
    'Namespace'  => $options['n'],
    'MetricName' => $options['m'],
    'Dimensions' => array(array('Name' => $options['d'], 'Value' => $options['v'])),
    'StartTime'  => strtotime('-'.$options['p'].' sec'),
    'EndTime'    => strtotime('now'),
    'Period'     => $options['p'],
    'Statistics' => array($options['s']),
));
 
//print_r($result);
foreach ($result as $k => $v)
{
	if($k === 'Datapoints')
	{
		echo $v['0'][$options['s']];
	}
}
