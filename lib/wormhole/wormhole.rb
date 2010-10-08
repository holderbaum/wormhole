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
        yield(namespaces(namespace)) if block_given?
        namespaces(namespace)
      end


      # yields a new config object on a uniqe-per-thread base and merges the via create configured object
      # of the same namespace into it
      #
      # @param [Symbol] namespace
      # @yield [config_backend.new] new config_backend instance with merged main config_backend instance
      # @return [config_backend.new] the manipulated config_backend instance
      def merge(namespace)
        @namespaces ||= {}
        Thread.current[:wormhole] ||= {}
        Thread.current[:wormhole][namespace] ||= config_backend.new
        Thread.current[:wormhole][namespace].merge!(@namespaces[namespace]) if @namespaces[namespace]

        yield( Thread.current[:wormhole][namespace] ) if block_given?
        Thread.current[:wormhole][namespace]
      end
      
      private
      def namespaces(key)
        @namespaces ||= {}
        @namespaces[key] ||= config_backend.new
      end

    end
  end

end
