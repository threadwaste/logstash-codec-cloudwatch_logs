# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/codecs/cloudwatch_logs"

describe LogStash::Codecs::CloudWatchLogs do
  let!(:compressed_data) do
    data = StringIO.new
    data << '{'
    data << '"owner":"123456789012",'
    data << '"logGroup":"CloudTrail",'
    data << '"logStream":"123456789012_CloudTrail_us-east-1",'
    data << '"subscriptionFilters":["RootAccess"],"messageType":"DATA_MESSAGE","logEvents":[{"id":"31953106606966983378809025079804211143289615424298221568","timestamp":1432826855000,"message":"first"},{"id":"31953106606966983378809025079804211143289615424298221569","timestamp":1432826855000,"message":"second"},{"id":"31953106606966983378809025079804211143289615424298221570","timestamp":1432826855000,"message":"third"}]}'

    data.rewind
    data
  end

  describe '#decode' do
    it 'decompresses and parses CloudWatch Logs data' do
      events = []

      zipped = StringIO.new('', 'r+b')
      zipper = Zlib::GzipWriter.new(zipped)
      zipper.write(compressed_data.read)
      zipper.finish

      zipped.rewind

      subject.decode(zipped.string) do |event|
        events << event
      end

      expect(events.size).to eq 3

      events.each do |event|
        expect(event['owner']).to eq '123456789012'
        expect(event['logGroup']).to eq 'CloudTrail'
        expect(event['logStream']).to eq '123456789012_CloudTrail_us-east-1'
        expect(event['subscriptionFilters']).to eq ['RootAccess']
        expect(event['messageType']).to eq 'DATA_MESSAGE'
      end

      messages = events.map { |e| e["message"] }
      expect(messages).to eq ["first", "second", "third"]
    end
  end
end
