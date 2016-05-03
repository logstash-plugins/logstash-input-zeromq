# encoding: utf-8
require_relative "../spec_helper"
require "logstash/plugin"
require "logstash/event"
require "securerandom"

def send_mock_messages(messages, &block)
  socket = double("socket")
  expect(socket).to receive(:recv_strings) do |arr|
    messages.each do |msg|
      msg.each do |frame|
        arr << frame
      end
    end
    0
  end
  plugin.instance_variable_set(:@zsocket, socket)
  q = []
  plugin.send(:handle_message, q)
  q
end

describe LogStash::Inputs::ZeroMQ, :zeromq => true do

  context "when register and close" do

    let(:plugin) { LogStash::Plugin.lookup("input", "zeromq").new({ "topology" => "pushpull" }) }

    it "should register and close without errors" do
      expect { plugin.register }.to_not raise_error
      expect { plugin.close }.to_not raise_error
    end

    context "when interrupting the plugin" do
      it_behaves_like "an interruptible input plugin" do
        let(:config) { { "topology" => "pushpull" } }
        after do
          subject.close
        end
      end
    end

  end

  context "pubsub" do
    topic_field = SecureRandom.hex
    let(:plugin) { LogStash::Plugin.lookup("input", "zeromq").new({"topology" => "pubsub", "topic_field" => topic_field}) }

    before do
      allow(plugin).to receive(:init_socket)
      plugin.register
    end

    it "should set the topic field with multiple message frames" do
      events = send_mock_messages([["topic", '{"message": "message"}', '{"message": "message2"}']])
      expect(events.first.get(topic_field)).to eq("topic")
      expect(events.first.get("message")).to eq("message")
      expect(events[1].get("message")).to eq("message2")
      expect(events[1].get(topic_field)).to eq("topic")
      expect(events.length).to eq(2)
    end
  end

  context "pushpull" do
    let(:plugin) { LogStash::Plugin.lookup("input", "zeromq").new({ "topology" => "pushpull" }) }

    before do
      allow(plugin).to receive(:init_socket)
      plugin.register
    end

    it "should receive multiple frames" do
      events = send_mock_messages([['{"message": "message"}', '{"message": "message2"}']])
      expect(events.first.get("message")).to eq("message")
      expect(events[1].get("message")).to eq("message2")
      expect(events.length).to eq(2)
    end
  end
end
