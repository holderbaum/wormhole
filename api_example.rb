

config/env.rb
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


helper.rb
<%= Wormhole.to_javascript %>
