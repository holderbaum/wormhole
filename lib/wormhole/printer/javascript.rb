module Wormhole
  module Printer
    class Javascript

      def self.out( hash )
        if hash.empty?
          ""
        else
          "var wormhole={};"+convert( "wormhole", hash )
        end
      end

      private
      def self.convert( namespace, hash )
        ret = ""
        hash.each do |key, value|
          if value.is_a?(String)
            value = '"'+value+'"'
          else
            value = value.to_s
          end
          ret += namespace+'.'+key.to_s+'='+value+';'
        end
        ret
      end

    end
  end
end
