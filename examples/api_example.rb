
#config/env.rb

# set config-backend, this class will be instanciated and yielded in a create/merge block
wormhole.config_backend = Wormhole::Config # this will be default

# create a global config-namespace, named foo
wormhole.create(:foo) do |c|
  c.bar = 42
  c.baz = "fooze"
end


# some Controller..
class Controller
  # yield a new config-namespace and merge an exisiting namespace-object into it (per-thread persistence)
  wormhole.merge(:foo) do |c| 
    c.bar? # => true
    c.baz? # => true

    c.baz = "foozefooze"
  end

  # yield and create a new config-namespace, also just persistent for this thread
  WOrmhole.merge(:bar) do |c|
    c.foo = "no bar"
  end
end


# a random view:
# this will build a javascript object with every namespace included
wormhole.to_javascript

# this will build a javascript object that contains only the foo namespace
wormhole.to_javascript(:foo)

# this will also build a javascript object, but with several namespaces
wormhole.to_javascript(:foo, :bar)

