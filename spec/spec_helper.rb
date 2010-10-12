require 'wormhole'

def cut_json(javascript, object = "Wormhole")
  JSON.parse /^var\s*#{object}\s*=\s*(\{.*\});$/.match(javascript)[1]
end

def threaded_it(*args, &block)
  Thread.new do
    it(*args, &block)
  end.join
end
