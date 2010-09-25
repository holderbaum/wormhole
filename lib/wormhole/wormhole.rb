module Wormhole
  module ClassMethods
    def config_backend
      @@config_backend ||= Config
    end
  end

  module InstanceMethods
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
