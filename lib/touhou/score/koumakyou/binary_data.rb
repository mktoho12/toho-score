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
          result = take_raw(current, len)
          @current += len
          result
        end

        def take_binary(pos, len)
          BinaryData.new(raw[pos, len])
        end

        def read_binary(len)
          result = take_binary(current, len)
          @current += len
          result
        end

        [:int8, :int16, :sint16, :int32, :sint32].each do |type|
          define_method("take_#{type}") do |pos|
            take(pos, type)
          end

          define_method("read_#{type}") do
            result = send "take_#{type}", current
            @current += type.match(/\d+$/)[0].to_i / 8
            result
          end
        end

        def eof?
          current >= raw.size
        end

        def bytes
          raw.unpack('C*')
        end

        def take(pos, type, len = 0)
          case type
          when :int8
            BinUtils.get_int8(raw, pos)
          when :int16
            BinUtils.get_int16_le(raw, pos)
          when :sint16
            BinUtils.get_sint16_le(raw, pos)
          when :int32
            BinUtils.get_int32_le(raw, pos)
          when :sint32
            BinUtils.get_sint32_le(raw, pos)
          end
        end
      end
    end
  end
end
