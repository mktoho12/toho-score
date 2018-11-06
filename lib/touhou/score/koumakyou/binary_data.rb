require 'bin_utils'

module Touhou
  module Score
    class Koumakyou
      # BinUtils wrapper
      class BinaryData
        attr_reader :raw, :current

        def initialize(raw)
          @raw = raw
          @current = 0
        end

        def read_raw(len)
          raw[current, len].tap { @current += len }
        end

        def read_binary(len)
          BinaryData.new read_raw(len)
        end

        def take_int(pos, len = 1)
          take_int_inner(pos, len, false)
        end

        def take_sint(pos, len = 1)
          take_int_inner(pos, len, true)
        end

        def read_int(len = 1)
          take_int(current, len).tap { @current += len }
        end

        def read_sint(len = 1)
          take_sint(current, len).tap { @current += len }
        end

        def eof?
          current >= raw.size
        end

        def bytes
          raw.unpack('C*')
        end

        private

        def take_int_inner(pos, len, signed)
          endianness = len == 1 ? '' : '_le'
          type = "#{signed ? :sint : :int}#{len * 8}" # int8 sint16 etc...
          method = "get_#{type}_#{endianness}"
          BinUtils.send(method, raw, pos)
        end
      end
    end
  end
end
