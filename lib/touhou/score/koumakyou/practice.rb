module Touhou
  module Score
    class Koumakyou
      # Scores of practice
      class Practice
        attr_reader :score, :chara, :level, :stage

        def initialize(data)
          data.read_int(4) # unknown
          @score = data.read_int(4, :sint)
          @chara = data.read_int
          @level = data.read_int
          @stage = data.read_int
        end
      end
    end
  end
end