# encoding: utf-8
require 'ffi-rzmq'

class ZeroMQClient

  attr_reader :addr, :port, :context, :requester

  def initialize(addr, port)
    @addr   = addr
    @port   = port
    @context = ZMQ::Context.new(1)
    @requester = context.socket(ZMQ::PUB)
    @requester.connect("tcp://#{addr}:#{port}")
  end

  def send(data)
    @requester.send_string(data)
  end

  def close
    @requester.close
    @context.terminate
  end
end
