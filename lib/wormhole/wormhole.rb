module Wormhole
  class Instance

    @namespaces = {}

    class << self # change self scope to metaclass of Instance

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
    end

    # creates a new wormhole namespace and yields a new config_backend instance
    #
    # @example Usage:
    #   Wormhole.create(:foo) do |config|
    #     config.bar = "fooze"
    #     config.class # => Wormhole::Config
    #   end
    #
    # @param [Symbol] namespace
    # @yield [config_backend.new] new config_backend instance 
    # @return [nil] TODO: define return-value
    def self.create(namespace)
      yield(@@namespaces[namespace] ||= config_backend.new)
    end
  end

end
