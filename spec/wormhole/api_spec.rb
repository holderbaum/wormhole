require 'spec_helper'

describe "Environment" do

  it "should respond to wormhole" do
    should respond_to(:wormhole)
  end

  it "should respond to Wormhole" do
    should respond_to(:Wormhole)
  end

  describe "wormhole" do

    it "should return an instance of Wormhole::Instance" do
      wormhole.should be_a(Wormhole::Instance)
    end

  end

  describe "API" do
  
    it "should enable a perfect story" do
      Wormhole.create(:foo) do |c|
        c.bar = 42
      end

      threaded do
        Wormhole(:foo) do |c|
          c.bar = 23
        end

        cut_json( Wormhole.to_javascript ).should == { "foo" => {"bar" => 23} }
      end

      cut_json( Wormhole.to_javascript ).should == { "foo" => {"bar" => 42} }
    end

  end

end
