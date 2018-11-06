module Touhou
  module Score
    module Koumakyou
      # cleared flag each difficulty.
      class ClearData
        attr_reader :s_easy, :s_normal, :s_hard, :s_lunatic, :s_extra,
                    :p_easy, :p_normal, :p_hard, :p_lunatic, :p_extra,
                    :chara

        def initialize(data)
          data.read_int(4) # unknown
          (@s_easy, @s_normal, @s_hard, @s_lunatic, @s_extra,
           @p_easy, @p_normal, @p_hard, @p_lunatic, @p_extra) =
            Array.new(10).map { data.read_int }
          @chara = data.read_int(2)
        end
      end
    end
  end
end