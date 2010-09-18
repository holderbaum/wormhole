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

  context "when one element added" do
    before { @config[:e1] = "elem" }
    specify { @config.wormhole_size.should == 1 }
  end

  context "when one element was created implicit" do
    before { @config[:element] }
    specify { @config.wormhole_size.should == 0 }
  end

  context "when one element was created implicit, but gets a value later" do
    before { @config[:element] }
    specify { @config.wormhole_size.should == 0 }
    specify do 
      @config[:element][:foo] = "bar"
      @config.wormhole_size.should == 1
    end
  end
end

