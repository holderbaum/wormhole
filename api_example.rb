

config/env.rb

Wormhole::Instance.config_backend = Wormhole::Config # this will be default

Wormhole::Instance.add_printer(:javascript, MyJSPrinter) # MyJSPrinter should implement   (String) out( (Hash) )
# everytime print with :javascript is called, the printers out method will be called with the object Hash as argument

Wormhole::Instance.create(:bla) do |config| # @@instance
  config.bla = 23
  config.foo = 42
end



class Controller
  Wormhole::Instance.merge(:bla) do |config| # Thread.current[:wormhole] ||= Wormhole.instance.dup
    config.foo = 23
  end

  Wormhole::Instance.merge(:bla) do |config|
    config.bar = "fasel"
  end
end


view:
# this will build a javascript object with every namespace included
<%= Wormhole::Instance.print( :javascript ) %>

# this will build a javascript object that contains only the foo and bar namespace
<%= Wormhole::Instance.print( [:foo,:bar], :javascript ) %>
