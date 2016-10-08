# encoding: utf-8
require 'logstash/codecs/base'
require 'logstash/timestamp'
require 'logstash/event'
require 'logstash/json'
require 'zlib'


# Parse CloudWatch Logs
class LogStash::Codecs::CloudWatchLogs < LogStash::Codecs::Base
  config_name "cloudwatch_logs"

  # Disable the gzip decompression phase if your events have already
  # been decompressed by the input processor.
  config :decompress, :validate => :boolean, :default => true

  public
  def register; end

  def decode(data, &block)
    data = decompress(StringIO.new(data)) if @decompress
    parse(LogStash::Json.load(data), &block)
  end

  private
  def decompress(data)
    gz = Zlib::GzipReader.new(data)
    gz.read
  rescue Zlib::Error, Zlib::GzipFile::Error => e
    @logger.error("Error decompressing CloudWatch Logs data: #{e}")
  end

  def parse(json, &block)
    events = json.delete("logEvents")
    json.freeze

    events.each do |event|
      epochmillis = event.delete("timestamp").to_i
      event[LogStash::Event::TIMESTAMP] = LogStash::Timestamp.at(epochmillis / 1000, (epochmillis % 1000) * 1000)
      yield LogStash::Event.new(json.merge(event))
    end
  end
end
