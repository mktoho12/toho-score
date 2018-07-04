module Touhou
  module Score
    class Koumakyou
      class Loader
        attr_reader :raw

        def self.load(file)
          Loader.new.load(IO.binread(file))
        end

        def load(data)
          @raw = decrypt(BinaryData.new(data))
          validate

          score = Touhou::Score::Koumakyou.new
          header_size = raw.take_int32(8)
          header = raw.read_binary(header_size)
          score.file_header = {
            unknown1: header.read_int16,
            checksum: header.read_int16,
            version: header.read_sint16,
            unknown2: header.read_int16,
            header_size: header.read_sint32,
            unknown3: header.read_int32,
            file_size: header.read_sint32
          }

          body = {}
          until raw.eof? do
            signature = raw.read_raw(4).to_sym
            chapter_size1 = raw.read_int16
            chapter_size2 = raw.read_int16
            body[signature] ||= []
            body[signature] << raw.read_binary(chapter_size1 - 8)
          end

          score.header = body[:TH6K].map{|d|{unknown: d.read_int32}}[0]
          score.high_scores = parse_high_score(body[:HSCR])
          score.clear_datas = parse_clear_data(body[:CLRD])
          score.spell_cards = parse_spell_card(body[:CATK])
          score.practices = parse_practice(body[:PSCR])
          score
        end

        def decrypt(data)
          BinaryData.new(decrypt_bytes(data.bytes).pack('C*'))
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
          raise unless calc_checksum == checksum
        end

        def calc_checksum
          # total from 5th byte to last at int16
          raw.bytes[4..-1].inject(:+) % 65536
        end

        def checksum
          # 3rd at int16
          raw.take_int16(2)
        end

        def parse_high_score(data)
          data.map do |s|
            {
              unknown: s.read_int32,
              score: s.read_int32,
              chara: s.read_int8,
              level: s.read_int8,
              stage_progress: s.read_int8,
              name: s.read_raw(8).strip
            }
          end
        end
        
        def parse_clear_data(data)
          data.map do |s|
            {
              unknown: s.read_int32,
              s_easy: s.read_int8,
              s_normal: s.read_int8,
              s_hard: s.read_int8,
              s_lunatic: s.read_int8,
              s_extra: s.read_int8,
              p_easy: s.read_int8,
              p_normal: s.read_int8,
              p_hard: s.read_int8,
              p_lunatic: s.read_int8,
              p_extra: s.read_int8,
              chara: s.read_int16
            }
          end
        end
    
        def parse_spell_card(data)
          data.map do |s|
            {
              unknown1: s.read_raw(8),
              card_id: s.read_int16,
              unknows2: s.read_raw(6),
              card_name: sjis(s.read_raw(36)),
              trial: s.read_int16,
              clear: s.read_int16
            }
          end
        end
    
        def parse_practice(data)
          data.map do |s|
            {
              unknown: s.read_int32,
              score: s.read_sint32,
              chara: s.read_int8,
              level: s.read_int8,
              stage: s.read_int8
            }
          end
        end
    
        def sjis(str)
          str.gsub(/[\0\n].*$/, '').force_encoding('Windows-31J').encode('UTF-8')
        end
      end
    end
  end
end

