module Wormhole
  class Config
    
    def initialize
      @hash = {}
    end

    def method_missing(meth, *args, &blk)
      if meth.to_s =~ /[a-zA-Z0-9]*=/
        return @hash[meth.to_s[0..-2].to_sym] = args[0]
      else
        return @hash[meth]
      end
    end


  end
end
