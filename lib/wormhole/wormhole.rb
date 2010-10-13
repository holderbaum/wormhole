module Wormhole
  class Instance

    def initialize
      @thread_key = "wormhole_#{hash}"
    end

    # returns the class that will be used as configuration-container
    #
    # @return [Const] classname
    def config_backend
      @config_backend ||= Config
    end

    # sets the configuration-container class
    #
    # @return [Const] new classname
    def config_backend=(config_class)
      @config_backend = config_class
    end


    # creates a new wormhole namespace and yields a new config_backend instance
    #
    # @example Usage:
    #   Wormhole.create(:foo) do |config|
    #     config.bar = "fooze"
    #     config.class # => config
    #   end
    #
    # @param [Symbol] namespace
    # @yield [config_backend.new] new config_backend instance
    # @return [config_backend.new] the manipulated config_backend instance
    def create(namespace)
      n = global_namespaces[namespace]
      yield(n) if block_given?
      n
    end


    # yields a new config object on a uniqe-per-thread base and merges the via create configured object
    # of the same namespace into it
    #
    # @param [Symbol] namespace
    # @yield [config_backend.new] new config_backend instance with merged main config_backend instance
    # @return [config_backend.new] the manipulated config_backend instance
    def merge(namespace)
      n = current_namespaces[namespace]
      yield(n) if block_given?
      n
    end

    # creates a ruby-hash from the wormhole object. Each of the different config-objects receives a to_hash,
    # the result will be nested into a key, named according to the namespace:
    #
    #   Wormhole.create(:foo).bar = 42
    #   Wormhole.create(:fooze).baz = 23
    #
    #   Wormhole.to_hash # => {:foo => {:bar => 42}, :fooze => {:baz => 23}}
    #
    # in addition, to_hash accepts the namespaces it should render as arguments:
    #
    #   Wormhole.to_hash(:foo)         # => {:foo => {:bar => 42}}
    #   Wormhole.to_hash(:foo, :fooze) # => {:foo => {:bar => 42}, :fooze => {:baz => 23}}
    #
    # @param [Symbol] numerous namespaces that should be rendered only as symbols
    # @return [Hash] the namespaces as a ruby-hash
    #
    def to_hash(*namespaces)
      hash = {}
      namespaces = global_namespaces.keys if namespaces.empty?
      cn = current_namespaces

      namespaces.each do |namespace|
        hash[namespace] = cn[namespace].to_hash
      end

      hash
    end

    # creates a javascript object via json. The object gets the following structure:
    #   Wormhole.namespace.config.object # => some value
    #   Wormhole.other_namespaces.config.object # => another value
    #
    # Optional you can pass one or more namespace-symbols as argument. If one or more
    # namespaces are given, only these will be included in the created javscript object.
    #
    # If no namespace is passed, every namespace will be included.
    #
    # @param [Symbol] namespaces to include
    # @return [String] namespaces as javascript-code
    def to_javascript(*args)
      json = JSON.generate(to_hash(*args))

      "var Wormhole = #{json};"
    end

    private

    # accessors
    def global_namespaces
      @global_namespaces ||= Hash.new { |hash, namespace| hash[namespace] = config_backend.new }
    end

    def current_namespaces
      Thread.current[@thread_key] ||= Hash.new { |hash, namespace| hash[namespace] = config_backend.new.merge!(global_namespaces[namespace]) }
    end
  end
end
