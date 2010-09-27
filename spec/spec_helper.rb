require 'wormhole'

def reset_test_class
  Object.send(:remove_const,:TestClass)
end
