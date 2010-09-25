require 'spec_helper'

describe Wormhole::Config do

  before do
    @config = Wormhole::Config.new
  end

  describe "attr_name=" do
    it "should never raise a NoMethodError" do
      lambda do
        @config.foo = "bar"
      end.should_not raise_error(NoMethodError)
    end

    it "should be callable on the end of concatenated attributes" do
      lambda do
        @config.foo.bar.fooze = "baz"
      end.should_not raise_error(NoMethodError)
    end
  end

  describe "attr_name" do
    it "should return the via attr= assigned value" do
      @config.foo = "bar"
      @config.foo.should == "bar"
    end


    it "should return the assigned value fo a concatenated key" do
      @config.foo.bar.baz = "fooze"
      @config.foo.bar.baz.should == "fooze"
    end
  end

  describe "attr_name?" do
    it "should be false for a never touched attr is called" do
      @config.barfooze?.should be_false
    end

    it "should be true for an assigned attr is called" do
      @config.barfooze = "noodles"
      @config.barfooze?.should be_true
    end

    it "should be false for an implicit created value while a nil-check" do
      @config.bar.foo?
      @config.bar?.should be_false
    end

    it "should be true for an implicit created value while an assignment" do
      @config.bar.fooze = 42
      @config.bar?.should be_true
    end

    it "should be false even after mutiple *? calls on the nested attributes" do
      @config.bar.foo?
      @config.bar.fooze?
      @config.bar.baz?

      @config.bar?.should be_false
    end

    it "should be true after assignments and *? calls on the nested attributes" do
      @config.foo.bar = 42
      @config.foo.baz = "zomg"
      @config.foo.fooze?

      @config.foo?.should be_true
    end
  end

  describe "to_hash" do
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

    it "should not be possible to change the config-object via the returned hash" do
      @config.foo = 23
      hash = @config.to_hash
      hash[:foo] = 42

      @config.foo.should == 23
    end
  end

  describe "empty?" do
    it "should be true if only implicit attribute where created" do
      @config.foo.bar?
      @config.fooze.baz?

      @config.should be_empty
    end

    it "should be false if attributes have assigned values" do
      @config.foo.bar?
      @config.baz = 42

      @config.should_not be_empty
    end

    it "should also be false if the assigned values are responding to empty?" do
      @config.string = ""
      @config.array = []
      @config.hash = {}

      @config.should_not be_empty
    end
  end


  describe "each" do

    it "should iterate over the attributes like a hash" do
      @config.bar = "foo"
      @config.baz = "fooze"

      hash = {}

      @config.each do |k,v|
        hash[k] = v
      end

      hash.should == { :bar => "foo", :baz => "fooze" }
    end

    it "should not convert nested config-objects to hashes" do
      @config.bar = "foo"
      @config.foo.bar = 42

      hash = {}

      @config.each do |k,v|
        hash[k] = v
      end

      hash[:foo].is_a?(Wormhole::Config).should be_true
    end
  end

  describe "merge!" do

    before do
      @merge_config = Wormhole::Config.new
    end
    
    it "should merge a flat and non-colliding config-object" do
      @config.bar = "foo"
      @merge_config.baz = "fooze"
      @config.merge! @merge_config

      @config.bar.should == "foo"
      @config.baz.should == "fooze"
    end

    it "should override in case of a collision" do
      @config.bar = "foo"
      @merge_config.bar = "fooze"
      @config.merge! @merge_config

      @config.bar.should == "fooze"
    end

    it "should deep-merge nested config elements" do
      @config.bar = "foo"
      @config.foo.bar = "foo"
      @merge_config.foo.baz = "fooze"
      @config.merge! @merge_config

      @config.foo.bar.should == "foo"
      @config.foo.baz.should == "fooze"
    end
  end

end
