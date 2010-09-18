require 'spec_helper'

describe Wormhole::Config do
  
  before { @config = Wormhole::Config.new }

  context "when created" do
    specify { @config.wormhole_size.should == 0 }
  end

  context "when uninitalized value requested" do
    specify { @config[:new_value].should_not be_nil }
    specify { @config[:another_value].class.should == Wormhole::Config }
  end

end

