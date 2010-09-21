module Wormhole
  # Flexible OpenStruct-like configuration container.
  #
  # @example Basic usage
  #   config = Wormhole::Config.new
  #   config.foo? # => false
  #   config.foo = 23
  #   config.foo # => 23
  #   config.foo? # => true
  #
  # @example Nested config
  #   config = Wormhole::Config.new
  #   config.foo.bar = 42
  #   config.foo.bar # => 42
  #   config.foo? # => true
  class Config

    def initialize
      @hash = {}
    end

    # Checks whether all sub values are +nil+ or +empty?+.
    #
    # @return [Boolean] +true+ if config is empty
    def empty?  
      @hash.all? do |_, value|
        _empty_value?(value)
      end
    end

    # Converts +config+ object to a +Hash+ - including nested values.
    #
    # @return [Hash] a regular hash
    def to_hash
      result = @hash.collect do |key, value|
        [ key, value.is_a?(Config) ? value.to_hash : value ]
      end
      Hash[result]
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
