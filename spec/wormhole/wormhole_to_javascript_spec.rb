require 'spec_helper'

describe Wormhole do

  before(:each) do
    @wormhole = Wormhole::Instance.new
  end

  describe "to_javascript without arguments" do

    it "should render a correct javascript declaration" do
      @wormhole.create(:foo) do |c|
        c.bar = 42
      end

      correct_declaration?(@wormhole.to_javascript).should be_true
    end

    it "should render an empty object from an empty wormhole" do
      cut_json( @wormhole.to_javascript ).should == {}
    end

    it "should include every namespace with nesting" do
      @wormhole.create(:foo) do |c|
        c.bar = 42
      end

      @wormhole.create(:bar) do |c|
        c.baz = 5
      end

      cut_json( @wormhole.to_javascript ).should == {
        "foo" => {"bar" => 42},
        "bar" => {"baz" => 5}
      }
    end

  end

  describe "to_javascript with arguments" do
    
  end

end
