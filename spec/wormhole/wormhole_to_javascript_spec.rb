require 'spec_helper'

describe Wormhole do

  before(:each) do
    @wormhole = Wormhole::Instance.dup
  end

  describe "to_javascript without arguments" do

    it "should create an empty javascript object if no namespaces where created" do
      cut_json(@wormhole.to_javascript).should == {}
    end

    it "should create a javascript object with the namespace as the first key" do
      @wormhole.create(:foo) do |config|
        config.bar = "baz"
      end

      cut_json( @wormhole.to_javascript ).should == { "foo" => { "bar" => "baz" } }
    end

    it "should create a javascript object from all namespaces" do
      @wormhole.create(:foo) do |config|
        config.fooze = 42
      end

      @wormhole.create(:bar) do |config|
        config.baz = 42
      end

      cut_json( @wormhole.to_javascript ).should == { "foo" => { "fooze" => 42 }, "bar" => { "baz" => 42 } }
    end

    it "should create a javascript object under consideration of the merge calls" do
      @wormhole.create(:foo) do |config|
        config.bar = 42
      end

      Thread.new do
        @wormhole.merge(:foo) do |config|
          config.baz = 43
        end

        cut_json( @wormhole.to_javascript ).should == { "foo" => { "bar" => 42, "baz" => 43 } }
      end.join
    end

  end

  describe "to_javascript with arguments" do
    
    it "should create a javascript object containing only the via args given namespace" do
      @wormhole.create(:foo) do |config|
        config.bar = 42
      end

      @wormhole.create(:bar) do |config|
        config.baz = 43
      end

      cut_json( @wormhole.to_javascript(:foo) ).should == { "foo" => { "bar" => 42 } }
    end

    it "should create a javascript object containing only the via args given namespaces under consideration of the merge calls" do
      @wormhole.create(:foo) do |config|
        config.bar = 42
      end

      Thread.new do
        @wormhole.merge(:foo) do |config|
          config.baz = 43
        end

        cut_json( @wormhole.to_javascript(:foo) ).should == { "foo" => { "bar" => 42, "baz" => 43 } }
      end.join
      
    end

    it "should create a javascript object containing two given namespaces" do
      @wormhole.create(:foo) do |config|
        config.fooze = 42
      end

      @wormhole.create(:bar) do |config|
        config.baz = 42
      end

      cut_json( @wormhole.to_javascript(:bar, :foo) ).should == { "foo" => { "fooze" => 42 }, "bar" => { "baz" => 42 } }
    end
  end

end
