module Wormhole
  class Instance

    class << self # change self scope to singleton of Instance

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
        n = find_or_create_global_namespace(namespace)
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
        n = find_or_create_current_namespace(namespace)
        yield(n) if block_given?
        n
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
      end

      private

      def find_or_create_global_namespace(namespace)
        namespaces[namespace] ||= config_backend.new
      end

      def find_or_create_current_namespace(namespace)
        current_namespaces[namespace] ||= config_backend.new.merge!( find_or_create_global_namespace(namespace) )
      end

      # accessors
      def namespaces
        @namespaces ||= {}
      end

      def current_namespaces
        Thread.current[:wormhole] ||= {}
      end

    end

  end
end
