require 'spec_helper'

describe "Environment" do

  it "should respond to wormhole" do
    should respond_to(:wormhole)
  end

  describe "wormhole" do

    # through the testing against Instance, we're able to assume,
    # that the entire Instance functionality is now accessible
    # through wormhole.
    # This makes any further API-testing futile
    it "should return the Wormhole::Instance class" do
      wormhole.should be(Wormhole::Instance)
    end

  end

end
