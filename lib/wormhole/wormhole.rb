module Wormhole
  class Instance

    @@namespaces = {}

    # returns the class that will be used as configuration-container
    #
    # @return [Const] classname
    def self.config_backend
      if self.class.class_variable_defined?("@@config_backend")
        self.class.send :class_variable_get, "@@config_backend"
      else
        self.class.send :class_variable_set, "@@config_backend", Config
      end
    end

    # sets the configuration-container class
    #
    # @return [Const] new classname
    def self.config_backend=(config_class)
      self.class.send :class_variable_set, "@@config_backend", config_class
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
