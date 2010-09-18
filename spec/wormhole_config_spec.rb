require 'spec_helper'

describe Wormhole::Config do
  
  before { @config = Wormhole::Config.new }

  context "when a _attr_name_= is called, it" do
    specify { lambda { @config.foo = "bar" }.should_not raise_error(NoMethodError) }
  end

  context "when the attr is called again, it" do
    before { @config.foo = "bar" }
    specify { @config.foo.should == "bar" }
  end

  context "when attributes are concatenated, they" do
    specify do
      lambda { @config.foo.bar.om = "nom" }.should_not raise_error(NoMethodError)
    end
  end

  context "when attributes are concatenated called, they" do
    before { @config.foo.bar.om = "nom" }
    specify { @config.foo.bar.om.should == "nom" }
    
  end
  #context "when created" do
    #specify { @config.wormhole_size.should == 0 }
  #end

  #context "when uninitalized value requested" do
    #specify { @config[:new_value].should_not be_nil }
    #specify { @config[:another_value].class.should == Wormhole::Config }
  #end

  #context "when one element added" do
    #before { @config[:e1] = "elem" }
    #specify { @config.wormhole_size.should == 1 }
  #end

  #context "when one element was created implicit" do
    #before { @config[:element] }
    #specify { @config.wormhole_size.should == 0 }
  #end

  #context "when one element was created implicit, but gets a value later" do
    #before { @config[:element] }
    #specify { @config.wormhole_size.should == 0 }
    #specify do 
      #@config[:element][:foo] = "bar"
      #@config.wormhole_size.should == 1
    #end
  #end

  #context "implicit value should not be counted by set?" do
    #specify { @config[:aa].should_not be_set }
  #end

  #context "implicit value should be counted by set? when used" do
    #before do
      #@config[:foo]
      #@config[:foo][:bar] = 2
    #end

    #specify { @config[:foo].should be_set }
  #end
end

