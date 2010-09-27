require 'spec_helper'

describe Wormhole do
  
  before do
    class TestClass
      include Wormhole
    end
  end
 
  after(:each) do
    reset_test_class
  end


  it 'should have a VERSION' do
    Wormhole::VERSION::STRING.should == "0.0.1"
  end

  describe "rspec test environment" do
    it "should set TestClass definition before every test" do
      Module::constants.include?("TestClass").should be_true
      def TestClass.monkey
        puts "patch"
      end
    end

    it "should reset the TestClass after every test" do
      TestClass.methods.include?("monkey").should be_false
    end
  end

  describe "self.config_backend" do
    it "should be set by default to Wormhole::Config" do
      TestClass.config_backend.should == Wormhole::Config
    end

    it "should be configurable" do
      TestClass.config_backend = Hash
      TestClass.config_backend.should == Hash
    end
  end

  describe "self.create" do
    it "should yield a block with an instance of the constance_backend as argument" do
      TestClass.create(:foo) do |config|
        config.is_a?(Wormhole::Config).should be_true
      end
    end

    it "should yield a block with the same config instance different times under one namespace " do
      instance = nil
      TestClass.create(:foo) do |config|
        instance = config
      end

      TestClass.create(:foo) do |config|
        config.should == instance
      end
    end
  end

  describe "self.merge" do
  end
end
