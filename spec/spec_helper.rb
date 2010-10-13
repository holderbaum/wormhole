require 'wormhole'

def correct_declaration?(javascript, object = "Wormhole")
  !/^var\s*#{object}\s*=\s*.*;$/.match(javascript).nil?
end

def cut_json(javascript, object = "Wormhole")
  JSON.parse /^var\s*#{object}\s*=\s*(\{.*\});$/.match(javascript)[1]
end

def threaded
  Thread.new do
    yield
  end.join
end
