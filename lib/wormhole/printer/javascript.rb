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
          if value.is_a?(Hash)
            new_namespace = namespace+'.'+key.to_s
            ret += new_namespace+'={};'
            ret += convert( new_namespace, value )
          else
            if value.is_a?(String)
              value = '"'+value+'"'
            else
              value = value.to_s
            end
            ret += namespace+'.'+key.to_s+'='+value+';'
          end
        end
        ret
      end

    end
  end
end
