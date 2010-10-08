module Wormhole #:nodoc:
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 0
    BUILD = 1

    STRING = [MAJOR, MINOR, BUILD].join('.')
  end

  module WormholeDispatcher
    def wormhole
      Wormhole::Instance
    end
  end
end

require 'wormhole/wormhole'
require 'wormhole/config'


class Object
  include Wormhole::WormholeDispatcher
end
