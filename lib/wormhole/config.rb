module Wormhole
  class Config
    
    def initialize
      @hash = {}
    end

    def empty?  
      @hash.all? do |_, value|
        _empty_value?(value)
      end
    end

    def _empty_value?(value) # :nodoc:
      value.is_a?(Config) && value.empty?
    end
    private :_empty_value?

    def method_missing(meth, *args, &blk)
      if meth.to_s =~ /[a-zA-Z0-9]*=/
        @hash[meth.to_s[0..-2].to_sym] = args[0]
      elsif meth.to_s =~ /[a-zA-Z0-9]*\?/
        meth = meth.to_s[0..-2].to_sym
        (value = @hash[meth]) && !_empty_value?(value)
      elsif @hash[meth].nil?
        @hash[meth] = self.class.new
      else
        @hash[meth]
      end
    end


  end
end
