require 'spec_helper'

describe Wormhole::Printer::Javascript do
  
  before(:each) do
    @printer = Wormhole::Printer::Javascript.dup
  end

  after(:each) do
    @printer = nil
  end
  

end
