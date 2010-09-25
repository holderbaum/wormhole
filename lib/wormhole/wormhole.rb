module Wormhole
  module ClassMethods

    @@namespaces = {}

    def config_backend
      @@config_backend ||= Config
    end

    def config_backend=(config_class)
      @@config_backend = config_class
    end

    def create(namespace)
      yield(@@namespaces[namespace] ||= config_backend.new)
    end
  end

  module InstanceMethods
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
