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
    it "should return a instance of Wormhole::Instance" do
      wormhole.should be_a(Wormhole::Instance)
    end

  end

end
