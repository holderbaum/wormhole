require 'spec_helper'

describe Wormhole do
  
  before do
    class TestClass
      include Wormhole
    end

    @test_class = TestClass.new
  end
  
  it 'should have a VERSION' do
    Wormhole::VERSION::STRING.should == "0.0.1"
  end

  describe "self.config_backend" do

    it "should be set by default to Wormhole::Config" do
      TestClass.config_backend.should == Wormhole::Config
    end

  end

end
