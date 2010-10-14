module Wormhole #:nodoc:
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 2
    BUILD = 0

    STRING = [MAJOR, MINOR, BUILD].join('.')
  end

  module WormholeDispatcher
    def wormhole
      Wormhole.instance
    end

    def Wormhole(*args, &block)
      Wormhole.instance.merge(*args, &block)
    end
  end

  def self.instance
    @instance ||= Wormhole::Instance.new
  end

  def self.create(*args, &block)
    instance.create(*args, &block)
  end

  def self.to_javascript(*args, &block)
    instance.to_javascript(*args, &block)
  end

end

require 'json'
require 'wormhole/wormhole'
require 'wormhole/config'


class Object
  include Wormhole::WormholeDispatcher
end
