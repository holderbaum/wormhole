require 'spec_helper'

describe Wormhole do
  
  before do
    @test_class = Class.new do
      include Wormhole
    end
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
    end

    it "should reset the test_class after every test" do
      @test_class.methods.include?("monkey").should be_false
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
  end

  describe "self.merge" do
  end
end
