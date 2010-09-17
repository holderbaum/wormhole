require 'spec_helper'

describe Wormhole::Config do
  
  before(:each) do
    @config = Wormhole::Config.new 
  end

  it "should be empty on creation" do
    @config.wormhole_size.should == 0
  end
end

