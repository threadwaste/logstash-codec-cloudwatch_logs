# Logstash Cloudwatch Logs Codec

[![Travis Build Status](https://travis-ci.org/threadwaste/logstash-codec-cloudwatch_logs.svg)](https://travis-ci.org/threadwaste/logstash-codec-cloudwatch_logs)

Parse [CloudWatch Logs subscriptions](http://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Subscriptions.html#DestinationKinesisExample) into individual events.

## Installation

This plugin can be installed by Logstash's plugin tool.

```
bin/logstash-plugin install logstash-codec-cloudwatch_logs
```

## Usage

At its simplest:

```
input {
  kinesis {
    kinesis_stream_name => "stream"
    codec => cloudwatch_logs
  }
}
```

### Event Format

The CloudWatch Logs codec breaks each multi-event subscription record into
individual events. It does this by iterating over the `logEvents` field, and
merging each event with all other top-level fields. The codec drops the
`logEvents` field from the final event.

For example, given a subscription record:

```
{
    "owner": "123456789012",
    "logGroup": "Example",
    "logStream": "Example1",
    "subscriptionFilters": [
        "RootAccess"
    ],
    "messageType": "DATA_MESSAGE",
    "logEvents": [
        {
            "id": "1",
            "timestamp": 1478014822000,
            "message": "event1"
        },
        {
            "id": "2",
            "timestamp": 1478014825000,
            "message": "event2"
        }
    ]
}
```

...this codec would yield two individual events:

```
[
  {
      "owner": "123456789012",
      "logGroup": "Example",
      "logStream": "Example1",
      "subscriptionFilters": [
          "RootAccess"
      ],
      "messageType": "DATA_MESSAGE",
      "id": "1",
      "timestamp": 1478014822000,
      "message": "event1"
  },
  {
      "owner": "123456789012",
      "logGroup": "Example",
      "logStream": "Example1",
      "subscriptionFilters": [
          "RootAccess"
      ],
      "messageType": "DATA_MESSAGE",
      "id": "2",
      "timestamp": 1478014825000,
      "message": "event2"
  }
]
```
