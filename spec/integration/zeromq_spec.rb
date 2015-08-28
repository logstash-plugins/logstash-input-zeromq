# encoding: utf-8
require_relative "../spec_helper"
require "logstash/plugin"
require "logstash/event"

describe LogStash::Inputs::ZeroMQ, :integration => true do

  describe "receive events" do

    let(:nevents)  { 10 }
    let(:port)     { rand(1000)+1025 }

    let(:conf) do
      {  "address" => ["tcp://127.0.0.1:#{port}"],
         "topology" => "pubsub" }
    end

    let(:events) do
      input(conf, nevents) do
        client = ZeroMQClient.new("127.0.0.1", port)
        nevents.times do |value|
          client.send("data #{value}")
        end
        client.close
      end
    end

    it "should receive the events" do
      expect(events.count).to be(nevents)
    end
  end
end
