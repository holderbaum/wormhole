
#config/env.rb

Wormhole.config_backend = Wormhole::Config # this will be default

Wormhole.add_printer(:javascript, MyJSPrinter) # MyJSPrinter should implement   (String) out( (Hash) )
# everytime print with :javascript is called, the printers out method will be called with the object Hash as argument

Wormhole.config(:foo).create do |config| # @@instance
  config.bla = 23
  config.foo = 42
end



class Controller
  Wormhole.config(:foo).merge do |config| # Thread.current[:wormhole] ||= Wormhole.instance.dup
    config.foo = 23
  end

  Wormhole.config(:bar).merge do |config|
    config.bar = "fasel"
  end
end


#view:
# this will build a javascript object with every namespace included
<%= Wormhole.config.print( :javascript ) %>

# this will build a javascript object that contains only the foo and bar namespace
<%= Wormhole.config(:foo).print( :javascript ) %>

