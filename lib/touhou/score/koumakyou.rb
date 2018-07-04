require 'bin_utils'

require 'touhou/score/koumakyou/binary_data'
require 'touhou/score/koumakyou/loader'

module Touhou
  module Score
    class Koumakyou

      def self.load(file)
        Loader.load(file)
      end
    
      attr_reader :raw, :data
      attr_accessor :file_header, :header, :high_scores, :clear_datas, :spell_cards, :practices
    
      def unknown1
        header[:unknown1]
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

