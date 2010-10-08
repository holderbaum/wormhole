class TestController < ApplicationController

  def index
    if params[:numer]
      wormhole.merge(:config) do |c|
        c.test = params[:number]
      end
    end
    # it seems, the view execution is NOT the same thread like the action itself ???
  end

end
