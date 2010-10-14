module Wormhole #:nodoc:
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 1
    BUILD = 0

    STRING = [MAJOR, MINOR, BUILD].join('.')
  end

  module WormholeDispatcher
    def wormhole
      @instance ||= Wormhole::Instance.new
    end

    def Wormhole(*args, &block)

    end
  end

  def self.create(*args,&block)
    wormhole.create(*args,&block)
  end

  def self.to_javascript(*args)
    wormhole.to_javascript(*args)
  end

end

require 'json'
require 'wormhole/wormhole'
require 'wormhole/config'


class Object
  include Wormhole::WormholeDispatcher
end
