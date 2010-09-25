module Wormhole
  module ClassMethods

    def config_backend
      @@config_backend ||= Config
    end

    def config_backend=(config_class)
      @@config_backend = config_class
    end

  end

  module InstanceMethods
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
