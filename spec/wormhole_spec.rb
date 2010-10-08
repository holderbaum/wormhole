require 'spec_helper'

describe Wormhole do

  before(:each) do
    @wormhole = Wormhole::Instance.dup
  end

  it 'should have a VERSION' do
    Wormhole::VERSION::STRING.should == "0.0.1"
  end

  describe "rspec test environment" do

    it "set the config_backend value" do
      @wormhole.config_backend = String
    end

    it "should reset the test_class after every test" do
      @wormhole.config_backend.should == Wormhole::Config
    end
  end

  describe "self.config_backend" do
    it "should be configurable" do
      @wormhole.config_backend = Hash
      @wormhole.config_backend.should == Hash
    end
  end

  describe "self.create" do
    it "should yield a block with an instance of the constant_backend as argument" do
      @wormhole.create(:foo) do |config|
        config.is_a?(Wormhole::Config).should be_true
      end
    end

    it "should yield a block with the same config instance different times under one namespace " do
      instance = nil
      @wormhole.create(:foo) do |config|
        instance = config
      end

      @wormhole.create(:foo) do |config|
        config.should == instance
      end
    end

    instance = nil
    it "should create a namespace" do
      @wormhole.create(:foo) do |config|
        instance = config
      end
    end

    it "should not be the same namespace in a following test" do
      @wormhole.create(:foo) do |config|
        instance.should_not == config
      end
    end

    it "should return the yielded config-backend instance" do
      instance = nil
      ret = @wormhole.create(:foo) do |config|
        instance = config
      end
      instance.should == ret
    end
    
    it "should return the config-backend instance if no block is given" do
      @wormhole.create(:foo).is_a?(Wormhole::Config).should be_true
    end
  end

  describe "self.merge" do
    it "should yield a block with an instance of the config_backend as an argument" do
      
      Thread.new do
        @wormhole.merge(:foo) do |config|
          config.is_a?(Wormhole::Config).should be_true
        end
      end.join

    end

    it "yielded config_backend instance should not be the same instance as under create" do
      instance = nil
      @wormhole.create(:foo) do |config|
        instance = config
      end

      Thread.new do
        @wormhole.merge(:foo) do |config|
          instance.should_not == config
        end
      end.join # thread

    end

    it "should yield the same config_backend instances under the same namespace in the same thread" do
      instance = nil

      Thread.new do
        @wormhole.merge(:foo) do |config|
          instance = config
        end

        @wormhole.merge(:foo) do |config|
          instance.should == config
        end
      end.join # thread

    end

    it "should yield individual config_backend instances for each thread" do
      instance_1 = nil
      instance_2 = nil

      Thread.new do
        @wormhole.merge(:foo) do |config|
          instance_1 = config
        end
      end.join # thread

      Thread.new do
        @wormhole.merge(:foo) do |config|
          instance_2 = config
        end
      end.join # thread

      instance_1.should_not == instance_2
    end

    it "should call merge! on the new config object with the instance of create" do
      @wormhole.create(:foo) do |config|
        config.bar = "fooze"
      end

      Thread.new do
        @wormhole.merge(:foo) do |config|
          config.bar.should == "fooze"
        end
      end.join # thread

    end

    it "should return the yielded object instance" do
      Thread.new do
        instance = nil
        ret = @wormhole.merge(:foo) do |config|
          instance = config
        end
        ret.should == instance
      end.join # thread
    end

    it "should return the object instance when no block is given" do
      Thread.new do
        ret = @wormhole.merge(:foo) do |config|

        end

        ret.should == @wormhole.merge(:foo)
      end
    end

    it "should only merge the first time with the created namespace" do
      @wormhole.create(:foo) do |config|
        config.baz = "fooze"
      end

      Thread.new do
        @wormhole.merge(:foo) do |config|
          config.baz = "nofooze"
        end

        @wormhole.merge(:foo) do |config|
          config.baz.should == "nofooze"
        end
      end.join # thread
      
    end
  end

  describe "to_javascript" do

    it "should create an empty javascript object when all namespaces are empty" do
      @wormhole.to_javascript.should =~ /^var\s*om\s*=\s*{};$/
    end

#  JSON.parse JSON.generate( {:foo => "bar", :baz => {:om => "nom"}} )
  end

end
