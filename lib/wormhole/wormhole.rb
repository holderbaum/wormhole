module Wormhole
	module ClassMethods
	end

	module InstanceMethods
	end

	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end
end
