module Wormhole
  class Config
    
    def initialize
      @hash = {}
    end

    def empty?  
      @hash.all? do |_, value|
        value.is_a?(Config) && value.empty?
      end
    end

    def method_missing(meth, *args, &blk)
      if meth.to_s =~ /[a-zA-Z0-9]*=/
        @hash[meth.to_s[0..-2].to_sym] = args[0]
      elsif meth.to_s =~ /[a-zA-Z0-9]*\?/
        meth = meth.to_s[0..-2].to_sym
        (value = @hash[meth]) && !(value.is_a?(Config) && value.empty?)
      elsif @hash[meth].nil?
        @hash[meth] = self.class.new
      else
        @hash[meth]
      end
    end


  end
end
