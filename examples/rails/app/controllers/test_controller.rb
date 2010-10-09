class TestController < ApplicationController

  def index
    if params[:number]
      wormhole.merge(:config) do |c|
        c.test = params[:number]
      end
    end
  end

end
