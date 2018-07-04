require 'bin_utils'

module Touhou
  module Score
    class Koumakyou
      class Loader
        attr_reader :raw

        def load(binary)
          @raw = decrypt(binary)
          validate
          raw
        end

        def decrypt(data)
          decrypt_bytes(data.unpack('C*')).pack('C*')
        end
    
        def decrypt_bytes(bytes)
          bytes[0..0] + (bytes[1..-1].inject({data: [], mask: 0}){|l,r|
            mask = switch_bit((l[:mask] + (l[:data].last || 0)) % 256)
            {data: l[:data] + [r ^ mask], mask: mask}
          })[:data]
        end
    
        def switch_bit(byte)
          (byte >> 5) | ((byte << 3) % 256)
        end

        def validate
          raise unless bytes[4..-1].inject(:+) % 65536 == BinUtils.get_int16_le(data, 2)
        end

        def bytes
          raw.unpack('C*')
        end
      end

      class << self
        def load(file)
          Koumakyou.new(Loader.new.load(IO.binread(file)))
        end
      end
    
      attr_reader :raw, :data
    
      def initialize(raw)
        @raw = raw
        @data = {}
        body = raw[self.header_size..-1]
        loop {
          break if body.nil? || body.empty?
          signature = body[0, 4].to_sym
          chapter_size = BinUtils.get_sint16_le(body, 4)
          data = body[0, chapter_size][8..-1]
          @data[signature] ||= []
          @data[signature] << data
          body = body[chapter_size..-1]
        }
      end
    
      def unknown1
        BinUtils.get_int16_le(@raw, 0)
      end
    
      def checksum
        BinUtils.get_int16_le(@raw, 2)
      end
    
      def version
        BinUtils.get_sint16_le(@raw, 4)
      end
    
      def unknown2
        BinUtils.get_int16_le(@raw, 6)
      end
    
      def header_size
        BinUtils.get_sint32_le(@raw, 8)
      end
    
      def unknown3
        BinUtils.get_int32_le(@raw, 12)
      end
    
      def data_size
        BinUtils.get_sint32_le(@raw, 16)
      end
    
      def high_score
        @data[:HSCR].map do |s|
          {
            score: BinUtils.get_sint32_le(s, 4),
            chara: BinUtils.get_int8(s, 8),
            level: BinUtils.get_int8(s, 9),
            stage_progress: BinUtils.get_int8(s, 10),
            name: s[11..-1].strip
          }
        end
      end
    
      def clear_data
        @data[:CLRD].map do |s|
          {
            s_easy: BinUtils.get_int8(s, 4),
            s_normal: BinUtils.get_int8(s, 5),
            s_hard: BinUtils.get_int8(s, 6),
            s_lunatic: BinUtils.get_int8(s, 7),
            s_extra: BinUtils.get_int8(s, 8),
            p_easy: BinUtils.get_int8(s, 9),
            p_normal: BinUtils.get_int8(s, 10),
            p_hard: BinUtils.get_int8(s, 11),
            p_lunatic: BinUtils.get_int8(s, 12),
            p_extra: BinUtils.get_int8(s, 13),
            chara: BinUtils.get_sint16_le(s, 14)
          }
        end
      end
    
      def spell_card
        @data[:CATK].map do |s|
          {
            unknown1: s[0, 8],
            card_id: BinUtils.get_sint16_le(s, 8),
            unknows2: s[10, 6],
            card_name: sjis(s[16, 36]),
            trial: BinUtils.get_sint16_le(s, 52),
            clear: BinUtils.get_sint16_le(s, 54)
          }
        end
      end
    
      def practice
        @data[:PSCR].map do |s|
          {
            score: BinUtils.get_sint32_le(s, 4),
            chara: BinUtils.get_int8(s, 8),
            level: BinUtils.get_int8(s, 9),
            stage: BinUtils.get_int8(s, 10)
          }
        end
      end
    
      def sjis(str)
        str.gsub(/[\0\n].*$/, '').force_encoding('Windows-31J').encode('UTF-8')
      end
    end
  end
end
