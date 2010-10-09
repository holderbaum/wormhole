module Wormhole #:nodoc:
  module VERSION #:nodoc:
    MAJOR = 1
    MINOR = 0
    BUILD = 0

    STRING = [MAJOR, MINOR, BUILD].join('.')
  end

  module WormholeDispatcher
    def wormhole
      Wormhole::Instance
    end
  end
end

require 'json'
require 'wormhole/wormhole'
require 'wormhole/config'


class Object
  include Wormhole::WormholeDispatcher
end
