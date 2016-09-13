# Logstash Cloudwatch Logs Codec

[![Travis Build Status](https://travis-ci.org/threadwaste/logstash-codec-cloudwatch_logs.svg)](https://travis-ci.org/threadwaste/logstash-codec-cloudwatch_logs)

Parse [CloudWatch Logs subscriptions](http://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Subscriptions.html#DestinationKinesisExample) sent to Kinesis.

## Usage

```
input {
  kinesis {
    kinesis_stream_name => "stream"
    codec => cloudwatch_logs
  }
}
```
