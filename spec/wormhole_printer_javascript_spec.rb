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

    it "should build a non nested object" do
      hash = { :foo => 42, :bar => "fooze" }
      @printer.out( hash ).should == 'var wormhole={};wormhole.bar="fooze";wormhole.foo=42;'
    end

    it "should convert also nested hashs" do
      hash = {  :foo => 42,
                :bar =>{
                  :fooze => "baz"}}

      @printer.out( hash ).should == 'var wormhole={};wormhole.bar={};wormhole.bar.fooze="baz";wormhole.foo=42;'
      
    end
  end

end
