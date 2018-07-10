module Touhou
  module Score
    class Koumakyou
      class BinaryData
        attr_reader :raw, :current
        
        def initialize(raw)
          @raw = raw
          @current = 0
        end

        def take_raw(pos, len)
          raw[pos, len]
        end

        def read_raw(len)
          take_raw(current, len).tap{ @current += len }
        end

        def take_binary(pos, len)
          BinaryData.new(raw[pos, len])
        end

        def read_binary(len)
          take_binary(current, len).tap{ @current += len }
        end

        TYPES = {
          int8:   { byte: 1, method: :get_int8 },
          int16:  { byte: 2, method: :get_int16_le },
          sint16: { byte: 2, method: :get_sint16_le },
          int32:  { byte: 4, method: :get_int32_le },
          sint32: { byte: 4, method: :get_sint32_le },
        }

        TYPES.each do |type_name, type|
          define_method("take_#{type_name}") do |pos|
            BinUtils.send(type[:method], raw, pos)
          end

          define_method("read_#{type_name}") do
            send("take_#{type_name}", current).tap{ @current += type[:byte] }
          end
        end

        def eof?
          current >= raw.size
        end

        def bytes
          raw.unpack('C*')
        end
      end
    end
  end
end
