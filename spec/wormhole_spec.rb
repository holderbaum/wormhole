require 'spec_helper'

describe Wormhole do
  
  before do
    class TestClass
      include Wormhole
    end

    @test_class = TestClass.new
  end
 
  after(:each) do
    reset_test_class
  end


  it 'should have a VERSION' do
    Wormhole::VERSION::STRING.should == "0.0.1"
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

  describe "create" do

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

end
