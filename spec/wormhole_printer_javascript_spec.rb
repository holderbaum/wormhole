require 'spec_helper'

describe Wormhole::Printer::Javascript do
  
  before(:each) do
    @printer = Wormhole::Printer::Javascript.dup
  end

  after(:each) do
    @printer = nil
  end
  
  describe "out" do

    it "should create '' from an empty Hash" do
      @printer.out({}).should == ''
    end

  end

end
