require 'spec_helper'

describe Wormhole::Config do
  
  before do
    @config = Wormhole::Config.new
  end

  it "should never raise a NoMethodError if [attr]= is called" do
    lambda do
      @config.foo = "bar"
    end.should_not raise_error(NoMethodError)
  end

  it "should return the via attr= assigned value when attr is called" do
    @config.foo = "bar"
    @config.foo.should == "bar"
  end

  it "should be possible to concatenate attributes and assign a value at the end" do
    lambda do
      @config.foo.bar.fooze = "baz"
    end.should_not raise_error(NoMethodError)
  end

  it "should return the assigned value fo a concatenated key" do
    @config.foo.bar.baz = "fooze"
    @config.foo.bar.baz.should == "fooze"
  end
  
  it "should return false if attr? for a never touched attr is called" do
    @config.barfooze?.should be_false
  end

  it "should return true if attr? for an assigned attr is called" do
    @config.barfooze = "noodles"
    @config.barfooze?.should be_true
  end

  it "should be empty if only implicit attribute where created" do
    @config.foo.bar?
    @config.fooze.baz?

    @config.should be_empty
  end
  
  it "should not be empty if attributes have assigned values" do
    @config.foo.bar?
    @config.baz = 42

    @config.should_not be_empty
  end

  it "should also not be empty if the assigned values are responding to empty?" do
    @config.string = ""
    @config.array = []
    @config.hash = {}

    @config.should_not be_empty
  end


  context "when _attr_name_? of a implicit created attr via *= is called, it" do
    before { @config.bar.fooze = 42 }
    specify { @config.bar?.should be_true }
  end

  context "when _attr_name_? of a implicit created attr via *? is called, it" do
    before { @config.bar.fooze }
    specify { @config.bar?.should be_false }
  end

  context "when _attr_name_? of a multiple times implicit created attr via *? is called, it" do
    before do
      @config.foo.bar?
      @config.foo.baz?
      @config.foo.foo? 
    end
    specify { @config.foo?.should be_false }
  end

  context "when attr_name_? of a implicit created attr via *? and *= is called, it" do
    before do
      @config.foo.bar = 42
      @config.foo.baz = "zomg"
      @config.foo.om?
    end
    specify { @config.foo?.should be_true }
  end

  it "should transform a flat config object into a hash" do
    @config.foo = 23
    @config.bar = "42"

    @config.to_hash.should == { :foo => 23, :bar => "42" }
  end

  it "should call to_hash on nested elements" do
    @config.foo = 42
    @config.bar = "fooze"
    @config.baz.fooze = 23

    @config.to_hash.should == { :foo => 42, :bar => "fooze", :baz => { :fooze => 23 } }        
  end

  it "should not be possible to change a config object by the via to_hash returned hash" do
    @config.foo = 23
    hash = @config.to_hash
    hash[:foo] = 42

    @config.foo.should == 23
  end
end
