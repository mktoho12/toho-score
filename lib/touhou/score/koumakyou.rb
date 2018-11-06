require 'touhou/score/koumakyou/binary_data'
require 'touhou/score/koumakyou/loader'

module Touhou
  module Score
    # Score file at Touhou Koumakyou the Embodiment of Scarlet Devil.
    class Koumakyou
      def self.load_score(file)
        Loader.load_score file
      end

      attr_accessor :file_header, :header, :high_scores, :clear_data,
                    :spell_cards, :practices

      def initialize(&block)
        instance_eval(&block) if block
      end
    end
  end
end
