module Touhou
  module Score
    module Koumakyou
      # High score each chara difficulty
      class HighScore
        attr_reader :score, :chara, :level, :stage_progress, :name

        def initialize(data)
          @score = data.read_int(4)
          @chara = data.read_int
          @level = data.read_int
          @stage_progress = data.read_int
          @name = data.read_raw(8).strip
        end
      end
    end
  end
end