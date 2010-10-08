require 'wormhole'

def cut_json(javascript, object = "Wormhole")
  JSON.parse /^var\s*#{object}\s*=\s*(\{.*\});$/.match(javascript)[1]
end

