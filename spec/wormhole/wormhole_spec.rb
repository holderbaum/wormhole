require 'spec_helper'

describe Wormhole do

  before(:each) do
    @wormhole = Wormhole::Instance.new
  end

  it 'should have a VERSION' do
    Wormhole::VERSION::STRING.should == "0.1.0"
  end

  describe "rspec test environment" do

    it "set the config_backend value" do
      @wormhole.config_backend = String
    end

    it "should reset the test_class after every test" do
      @wormhole.config_backend.should == Wormhole::Config
    end
  end

  describe "self.config_backend" do
    it "should be configurable" do
      @wormhole.config_backend = Hash
      @wormhole.config_backend.should == Hash
    end
  end

  describe "self.create" do
    it "should yield a block with an instance of the constant_backend as argument" do
      @wormhole.create(:foo) do |config|
        config.is_a?(Wormhole::Config).should be_true
      end
    end

    it "should yield a block with the same config instance different times under one namespace " do
      instance = nil
      @wormhole.create(:foo) do |config|
        instance = config
      end

      @wormhole.create(:foo) do |config|
        config.should == instance
      end
    end

    instance = nil
    it "should create a namespace" do
      @wormhole.create(:foo) do |config|
        instance = config
      end
    end

    it "should not be the same namespace in a following test" do
      @wormhole.create(:foo) do |config|
        instance.should_not == config
      end
    end

    it "should return the yielded config-backend instance" do
      instance = nil
      ret = @wormhole.create(:foo) do |config|
        instance = config
      end
      instance.should == ret
    end

    it "should return the config-backend instance if no block is given" do
      @wormhole.create(:foo).is_a?(Wormhole::Config).should be_true
    end
  end

  describe "self.merge" do
    it "should yield a block with an instance of the config_backend as an argument" do

      threaded do
        @wormhole.merge(:foo) do |config|
          config.is_a?(Wormhole::Config).should be_true
        end
      end

    end

    it "yielded config_backend instance should not be the same instance as under create" do
      instance = nil
      @wormhole.create(:foo) do |config|
        instance = config
      end

      threaded do
        @wormhole.merge(:foo) do |config|
          instance.should_not == config
        end
      end

    end

    it "should yield the same config_backend instances under the same namespace in the same thread" do
      instance = nil

      threaded do
        @wormhole.merge(:foo) do |config|
          instance = config
        end

        @wormhole.merge(:foo) do |config|
          instance.should == config
        end
      end

    end

    it "should yield individual config_backend instances for each thread" do
      instance_1 = nil
      instance_2 = nil

      threaded do
        @wormhole.merge(:foo) do |config|
          instance_1 = config
        end
      end

      threaded do
        @wormhole.merge(:foo) do |config|
          instance_2 = config
        end
      end

      instance_1.should_not == instance_2
    end

    it "should call merge! on the new config object with the instance of create" do
      @wormhole.create(:foo) do |config|
        config.bar = "fooze"
      end

      threaded do
        @wormhole.merge(:foo) do |config|
          config.bar.should == "fooze"
        end
      end

    end

    it "should return the yielded object instance" do
      threaded do
        instance = nil
        ret = @wormhole.merge(:foo) do |config|
          instance = config
        end
        ret.should == instance
      end
    end

    it "should return the object instance when no block is given" do
      threaded do
        ret = @wormhole.merge(:foo) do |config|

        end

        ret.should == @wormhole.merge(:foo)
      end
    end

    it "should only merge the first time with the created namespace" do
      @wormhole.create(:foo) do |config|
        config.baz = "fooze"
      end

      threaded do
        @wormhole.merge(:foo) do |config|
          config.baz = "nofooze"
        end

        @wormhole.merge(:foo) do |config|
          config.baz.should == "nofooze"
        end
      end

    end

    it "should handle 2 Instance in one thread seperately" do
      instance1 = Wormhole::Instance.new
      instance1.create(:foo).bar = 23
      instance2 = Wormhole::Instance.new
      instance2.create(:foo).bar = 42

      threaded do
        instance1.merge(:foo).bar = 42
      end

      threaded do
        instance2.merge(:foo).bar = 23
      end

      instance1.to_hash.should == { :foo => { :bar => 23 } }
      instance2.to_hash.should == { :foo => { :bar => 42 } }
    end
  end

  describe "to_hash without argument" do
    
    it "should create an empty hash if no namespaces where created" do
      @wormhole.to_hash.should == {}
    end

    it "should create a hash with the namespace as the first key" do
      @wormhole.create(:foo) do |config|
        config.bar = "baz"
      end

      @wormhole.to_hash.should == { :foo => { :bar => "baz" } }
    end

    it "should create a hash from all namespaces" do
      @wormhole.create(:foo) do |config|
        config.fooze = 42
      end

      @wormhole.create(:bar) do |config|
        config.baz = 42
      end

      @wormhole.to_hash.should == { :foo => { :fooze => 42 }, :bar => { :baz => 42 } }
    end

    it "should create a hash under consideration of the merge calls" do
      @wormhole.create(:foo) do |config|
        config.bar = 42
      end

      threaded do
        @wormhole.merge(:foo) do |config|
          config.baz = 43
        end

        @wormhole.to_hash.should == { :foo => { :bar => 42, :baz => 43 } }
      end
    end
  end


  describe "to_hash with arguments" do
    
    it "should create a hash containing only the via args given namespace" do
      @wormhole.create(:foo) do |config|
        config.bar = 42
      end

      @wormhole.create(:bar) do |config|
        config.baz = 43
      end

      @wormhole.to_hash(:foo).should == { :foo => { :bar => 42 } }
    end

    it "should create a hash containing only the via args given namespaces under consideration of the merge calls" do
      @wormhole.create(:foo) do |config|
        config.bar = 42
      end

      threaded do
        @wormhole.merge(:foo) do |config|
          config.baz = 43
        end

        @wormhole.to_hash(:foo).should == { :foo => { :bar => 42, :baz => 43 } }
      end
      
    end

    it "should create a hash containing two given namespaces" do
      @wormhole.create(:foo) do |config|
        config.fooze = 42
      end

      @wormhole.create(:bar) do |config|
        config.baz = 42
      end

      @wormhole.to_hash(:bar, :foo).should == { :foo => { :fooze => 42 }, :bar => { :baz => 42 } }
    end
  end

end
