module Touhou
  module Score
    class Koumakyou
      # score.dat file loader
      class Loader
        attr_reader :raw

        def self.load_score(file)
          Loader.new.read IO.binread(file)
        end

        SIGNATURES = { TH6K: Array, HSCR: HighScore, CLRD: ClearData,
                       CATK: SpellCard, PSCR: Practice }.freeze

        def read(data)
          @raw = decrypt(BinaryData.new(data))
          validate
          Touhou::Score::Koumakyou.new do
            @file_header = Header.new(read_header_binary)
            @header, @high_scores, @clear_data, @high_scores, @practices =
              read_body.values_at(:TH6K, :HSCR, :CLRD, :HSCR, :PSCR)
          end
        end

        def header_size
          raw.take_int(8, 4)
        end

        def read_header_binary
          raw.read_binary(header_size)
        end

        def read_body
          body = Hash.new { |h, k| h[k] = [] }
          until raw.eof?
            signature, data = read_chapter.values
            body[signature] << SIGNATURES[signature].new(data)
          end
          body
        end

        def read_chapter
          signature = raw.read_raw(4).to_sym
          chapter_size1 = raw.read_int(2)
          raw.read_int(2) # chapter_size2 unused
          { signature: signature, data: raw.read_binary(chapter_size1 - 8) }
        end

        def decrypt(data)
          BinaryData.new(decrypt_bytes(data.bytes).pack('C*'))
        end

        def decrypt_bytes(bytes)
          bytes[0..0] + (bytes[1..-1].inject(data: [], mask: 0) do |l, r|
            mask = switch_bit((l[:mask] + (l[:data].last || 0)) % 256)
            { data: l[:data] + [r ^ mask], mask: mask }
          end)[:data]
        end

        def switch_bit(byte)
          (byte >> 5) | ((byte << 3) % 256)
        end

        def validate
          raise unless calc_checksum == checksum
        end

        def calc_checksum
          # total from 5th byte to last at int16
          raw.bytes[4..-1].inject(:+) % 65_536
        end

        def checksum
          # 3rd at int16
          raw.take_int(2, 2)
        end
      end
    end
  end
end
