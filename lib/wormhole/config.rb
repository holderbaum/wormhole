module Wormhole
  class Config
    
    def initialize
      @hash = {}
    end

    def empty?  
      return @hash.select do |k,v| 
        v.class != Wormhole::Config or (v.class == Wormhole::Config and !v.empty?) 
      end.size == 0
    end

    def method_missing(meth, *args, &blk)
      if meth.to_s =~ /[a-zA-Z0-9]*=/
        return @hash[meth.to_s[0..-2].to_sym] = args[0]
      elsif meth.to_s =~ /[a-zA-Z0-9]*\?/
        meth = meth.to_s[0..-2].to_sym
        if @hash[meth].nil?
          return false
        else
          if @hash[meth].class == Wormhole::Config and @hash[meth].empty?
            return  false
          else
            return true
          end
        end
      elsif @hash[meth].nil?
        return @hash[meth] = self.class.new
      else
        return @hash[meth]
      end
    end


  end
end
