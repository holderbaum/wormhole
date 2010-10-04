

config/env.rb

Wormhole.config_backend = Wormhole::Config # this will be default

Wormhole.create(:bla) do |config| # @@instance
  config.bla = 23
  config.foo = 42
end



class Controller
  Wormhole.merge(:bla) do |config| # Thread.current[:wormhole] ||= Wormhole.instance.dup
    config.foo = 23
  end

  Wormhole.merge(:bla) do |config|
    config.bar = "fasel"
  end
end


view:
<%= Wormhole.print.to(:javascript) %>
# print should be a wrapper for different printing-backends
