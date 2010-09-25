require 'wormhole'

def reset_test_class
  TestClass.config_backend = Wormhole::Config
end
