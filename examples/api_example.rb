
#config/env.rb

# set config-backend, this class will be instanciated and yielded in a create/merge block
Wormhole.config_backend = Wormhole::Config # this will be default

# create a global config-namespace, named foo
Wormhole.create(:foo) do |c|
  c.bar = 42
  c.baz = "fooze"
end


# some Controller..
class Controller
  # yield a new config-namespace and merge an exisiting namespace-object into it (per-thread persistence)
  Wormhole.merge(:foo) do |c| 
    c.bar? # => true
    c.baz? # => true

    c.baz = "foozefooze"
  end

  # yield and create a new config-namespace, also just persistent for this thread
  Wormhole.merge(:bar) do |c|
    c.foo = "no bar"
  end
end


# a random view:
# this will build a javascript object with every namespace included
Wormhole.to_javascript

# this will build a javascript object that contains only the foo namespace
Wormhole.to_javascript(:foo)

# this will also build a javascript object, but with several namespaces
Wormhole.to_javascript(:foo, :bar)

