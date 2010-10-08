# irb -r dispatch_example -- in this shell, Wormhole::Instance is accessible through wormhole
module Wormhole

  class Instance
    class << self
      def foo
        "bar"
      end
    end
  end


  module WormholeDispatcher
    def wormhole
      Wormhole::Instance
    end
  end

end


class Object
  include Wormhole::WormholeDispatcher
  extend Wormhole::WormholeDispatcher
end
