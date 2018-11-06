module Touhou
  module Score
    module Koumakyou
      # Got spell card count and challenges
      class SpellCard
        attr_reader :card_id, :card_name, :trial, :clear

        def initialize(data)
          data.read_raw(8) # unknown
          @card_id = data.read_int(2)
          data.read_raw(6) # unknown
          @card_name = sjis(data.read_raw(36))
          @trial = data.read_int(2)
          @clear = data.read_int(2)
        end

        private

        def sjis(str)
          str.gsub(/[\0\n].*$/, '').force_encoding('Windows-31J').encode 'UTF-8'
        end
      end
    end
  end
end
