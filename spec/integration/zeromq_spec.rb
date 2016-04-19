# encoding: utf-8
require_relative "../spec_helper"
require "logstash/plugin"
require "logstash/event"
require "json"

describe LogStash::Inputs::ZeroMQ, :integration => true do

  let(:helpers) { ZeroMQHelpers.new }

  describe "receive events" do

    let(:nevents)  { 10 }
    let(:port)     { rand(1000)+1025 }

    let(:conf) do
      {  "address" => ["tcp://127.0.0.1:#{port}"],
         "topology" => "pubsub" }
    end

    let(:events) do
      helpers.input(conf, nevents) do
        client = ZeroMQClient.new("127.0.0.1", port)
        nevents.times do |value|
          client.send("TOPIC", ZMQ::SNDMORE)
          client.send({"message" => "data #{value}"}.to_json)
        end
        client.close
      end
    end

    it "should receive the events" do
      expect(events.count).to be(nevents)
      expect(events.map(&:to_hash)).to all(include("topic" => "TOPIC"))
    end
  end
end
