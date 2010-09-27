require 'spec_helper'

describe Wormhole do
  
  before do
    @test_class = Class.new do
      include Wormhole
    end
  end

  after(:each) do
    Object.send(:remove_const, :test_class)
  end

  it 'should have a VERSION' do
    Wormhole::VERSION::STRING.should == "0.0.1"
  end

  describe "rspec test environment" do
    it "should set test_class definition before every test" do
      @test_class.class.should == Class
      def @test_class.monkey
        puts "patch"
      end

      def @test_class.set_class_var
        @@class_var = "foo"
      end

      @test_class.set_class_var
    end

    it "should reset the test_class after every test" do
      @test_class.methods.include?("monkey").should be_false
      @test_class.class_variables.should be_empty
    end
  end

  describe "self.config_backend" do
    it "should be set by default to Wormhole::Config" do
      @test_class.config_backend.should == Wormhole::Config
    end

    it "should be configurable" do
      @test_class.config_backend = Hash
      @test_class.config_backend.should == Hash
    end
  end

  describe "self.create" do
    it "should yield a block with an instance of the constance_backend as argument" do
      @test_class.create(:foo) do |config|
        puts "testsss"
        puts config.class
        config.is_a?(Wormhole::Config).should be_true
      end
    end

    it "should yield a block with the same config instance different times under one namespace " do
      instance = nil
      @test_class.create(:foo) do |config|
        instance = config
      end

      @test_class.create(:foo) do |config|
        config.should == instance
      end
    end

    it "should return the yielded config-backend instance" do
      instance = nil
      ret = @test_class.create(:foo) do |config|
        instance = config
      end
      instance.should == ret
    end
  end

  describe "self.merge" do
    it "should yield a block with an instance of the config_backend as an argument" do
      @test_class.merge(:foo) do |config|
        config.is_a?(Wormhole::Config).should be_true
      end
    end

    it "yielded config_backend instance should not be the same instance as under create" do
      instance = nil
      @test_class.create(:foo) do |config|
        instance = config
      end

      @test_class.merge(:foo) do |config|
        instance.should_not == config
      end
    end

    it "should yield the same config_backend instances under the same namespace" do
      instance = nil
      @test_class.merge(:foo) do |config|
        instance = config
      end

      @test_class.merge(:foo) do |config|
        instance.should == config
      end
    end
  end
end
