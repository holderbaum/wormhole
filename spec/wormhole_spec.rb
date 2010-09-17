require 'spec_helper'

describe Wormhole do
  it 'should have a VERSION' do
    Wormhole::VERSION::STRING.should == "0.0.1"
  end
end

