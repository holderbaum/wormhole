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

  context "when _attr_name_? for a never touched attr is called, it" do
    specify { @config.barfooze?.should be_false }
  end

  context "when _attr_name_? for a setted attr is called, it" do
    before { @config.barfooze = "noodles" }
    specify { @config.barfooze?.should be_true }
    
  end

  context "when only implicit attributes, it" do
    before { @config.aa.bb? }
    specify { @config.should be_empty }
  end

  context "when a real attr comes in addition, it" do
    before do
      @config.foo.bar?
      @config.bar = "fooze"
    end
    specify { @config.should_not be_empty }
  end

  context "when attributes added which respond to emtpy?, it" do
    before do
      @config.string = ""
      @config.array = []
      @config.hash = {}
    end
    specify { @config.should_not be_empty }
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

  context "when to_hash without nesting is called, it" do
    before do
      @config.foo = 23
      @config.bar = "42"
    end
    specify { @config.to_hash.should == { :foo => 23, :bar => "42" } } 
  end

  context "when to_hash with nested values is called, it" do
    before do
      @config.foo = 23
      @config.bar = "42"
      @config.baz.fooze = "deep"
    end
    specify { @config.to_hash.should == { :foo => 23, :bar => "42", :baz => { :fooze => "deep" } } } 
  end

  context "when result of to_hash is modified, it" do
    before do
      @config.foo = 23
      hash = @config.to_hash
      hash[:foo] = 42
    end
    specify { @config.foo.should == 23 }
  end

  context "when merge with a non-nested hash is called, it" do
    before do
      @config.foo = "bar"
      @hash = { :baz => "fooze" }
      @config.merge! @hash
      @hash.merge! :foo => "bar"
    end
    specify { @config.to_hash.should == @hash }
  end

  context "when merge with a collision is called, it" do
    before do
      @config.baz = "fooze"
      @hash = { :baz => "foo" }
      @config.merge! @hash
    end
    specify { @config.to_hash.should == { :baz => "fooze"} }
  end

  context "when merged with a nested hash, it" do
    before do
      @config.baz = "fooze"
      @hash = { :foo => "bar", :the => { :solution => 42 } }
      @config.merge! @hash
    end
    specify { @config.to_hash.should == { :foo => "bar", :baz => "fooze", :the => { :solution => 42 }} }
  end

  context "when merged with a nested hash and collison, it" do
    before do
      @config.baz = "fooze"
      @config.foo.bar = 42
      @config.foo.baz = "fooze"

      @hash = { :foo => { :fooze => 42} }

      @config.merge! @hash
    end
    specify { @config.to_hash.should == { :baz => "fooze", :foo => { :bar => 42, :baz => "fooze", :fooze => 42} } }
    
  end
end
