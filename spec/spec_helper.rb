# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/inputs/zeromq"
require_relative "support/client"

module ZeroMQHelpers

  def setup_clients(number_of_clients, port)
    number_of_clients.times.inject([]) do |clients|
      clients << ZeroMQClient.new(localhost, port)
    end
  end

  def input(config, size, &block)
    plugin = LogStash::Plugin.lookup("input", "zeromq").new(config)
    plugin.register
    queue  = Queue.new

    pipeline_thread = Thread.new { plugin.run(queue) }
    sleep 0.3
    block.call
    sleep 0.1 while queue.size != size
    result = size.times.inject([]) do |acc|
      acc << queue.pop
    end
    plugin.do_stop
    pipeline_thread.join
    result
  end # def input

end

RSpec.configure do |config|
  config.include ZeroMQHelpers
  config.filter_run_excluding({ :zeromq => true, :integration => true })
  config.order = :random
end
