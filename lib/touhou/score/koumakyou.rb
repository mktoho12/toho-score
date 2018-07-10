require 'touhou/score/koumakyou/binary_data'
require 'touhou/score/koumakyou/loader'

module Touhou
  module Score
    class Koumakyou
      def self.load(file)
        Loader.load(file)
      end

      attr_accessor :file_header, :header, :high_scores, :clear_datas, :spell_cards, :practices
    end
  end
end
