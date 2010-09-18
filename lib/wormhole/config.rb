module Wormhole
  class Config
    # since we want a struct like concatination of indexes, every public method will be prefixed by wormhole_
    # this looks like a dirty woraround, but I'm thinking about some kind of a dynamic alias-system vie method_missing
    #  but until now, we will use wormhole_*

    def initialize
      @hash = {}
    end

    def wormhole_size
      0
    end

    def []=(key,value)
      @hash[key] = value
    end

    def [](key)
      @hash[key] ||= self.class.new
    end

  end
end
