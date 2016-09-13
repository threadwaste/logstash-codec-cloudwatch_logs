# encoding: utf-8
require "logstash/codecs/base"
require 'logstash/json'
require 'zlib'


# Parse CloudWatch Logs
class LogStash::Codecs::CloudWatchLogs < LogStash::Codecs::Base
  config_name "cloudwatch_logs"

  public
  def register; end

  def decode(data, &block)
    data = decompress(StringIO.new(data))
    parse(LogStash::Json.load(data), &block)
  end

  private
  def decompress(data)
    gz = Zlib::GzipReader.new(data)
    gz.read
  rescue Zlib::Error, Zlib::GzipFile::Error => e
    @logger.error("oops: #{e}")
  end

  def parse(json, &block)
    base = json.reject { |k,_| k == "logEvents" }.freeze
    events = json["logEvents"]

    events.each do |event|
      yield LogStash::Event.new(base.merge(event))
    end
  end
end
