require 'spec_helper'

describe "Environment" do

  it "should respond to wormhole" do
    should respond_to(:wormhole)
  end

  describe "wormhole" do

    it "should return the Wormhole::Instance class" do
      wormhole.should be(Wormhole::Instance)
    end

  end

end
