require 'spec_helper'

describe Wormhole do
 
  before(:each) do
    Wormhole::Instance.freeze
    @wormhole = Wormhole::Instance.dup
  end

  after(:each) do
    @wormhole = nil
  end

  it 'should have a VERSION' do
    Wormhole::VERSION::STRING.should == "0.0.1"
  end

  describe "rspec test environment" do
    
    it "set the config_backend value" do
      puts @wormhole
      @wormhole.config_backend = String
    end

    it "should reset the test_class after every test" do
      puts @wormhole
      @wormhole.config_backend.should == Wormhole::Config
    end
  end

  describe "self.config_backend" do
    it "should be set by default to Wormhole::Config" do
      puts Wormhole::Instance.config_backend.class
      #Wormhole::Instance.config_backend.should == Wormhole::Config
    end

    it "should be configurable" do
      Wormhole::Instance.config_backend = Hash
      Wormhole::Instance.config_backend.should == Hash
    end
  end

  describe "self.create" do
    it "should yield a block with an instance of the constance_backend as argument" do
      Wormhole::Instance.create(:foo) do |config|
        puts "testsss"
        puts config.class
        config.is_a?(Wormhole::Config).should be_true
      end
    end

    it "should yield a block with the same config instance different times under one namespace " do
      instance = nil
      Wormhole::Instance.create(:foo) do |config|
        instance = config
      end

      Wormhole::Instance.create(:foo) do |config|
        config.should == instance
      end
    end

    it "should return the yielded config-backend instance" do
      instance = nil
      ret = Wormhole::Instance.create(:foo) do |config|
        instance = config
      end
      instance.should == ret
    end
  end

  describe "self.merge" do
    it "should yield a block with an instance of the config_backend as an argument" do
      Wormhole::Instance.merge(:foo) do |config|
        config.is_a?(Wormhole::Config).should be_true
      end
    end

    it "yielded config_backend instance should not be the same instance as under create" do
      instance = nil
      Wormhole::Instance.create(:foo) do |config|
        instance = config
      end

      Wormhole::Instance.merge(:foo) do |config|
        instance.should_not == config
      end
    end

    it "should yield the same config_backend instances under the same namespace" do
      instance = nil
      Wormhole::Instance.merge(:foo) do |config|
        instance = config
      end

      Wormhole::Instance.merge(:foo) do |config|
        instance.should == config
      end
    end
  end
end
