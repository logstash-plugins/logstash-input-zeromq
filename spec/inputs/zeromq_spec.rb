# encoding: utf-8
require_relative "../spec_helper"
require "logstash/plugin"
require "logstash/event"

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
end
