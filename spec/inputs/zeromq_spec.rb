# encoding: utf-8
require_relative "../spec_helper"
require "logstash/plugin"
require "logstash/event"

describe LogStash::Inputs::ZeroMQ, :zeromq => true do

  context "when register and teardown" do

    let(:plugin) { LogStash::Plugin.lookup("input", "zeromq").new({ "topology" => "pushpull" }) }

    it "should register and teardown without errors" do
      expect { plugin.register }.to_not raise_error
      expect { plugin.teardown }.to_not raise_error
    end

  end

end
