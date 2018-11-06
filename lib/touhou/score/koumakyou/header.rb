module Touhou
  module Score
    module Koumakyou
      # Score file header
      class Header
        attr_reader :checksum, :version, :size, :file_size

        def initialize(data)
          data.read_int(2) # unknown
          @checksum = data.read_int(2)
          @version = data.read_int(2, true)
          data.read_int(2) # unknown
          @size = data.read_int(4, true)
          data.read_int(4) # unknown
          @file_size = data.read_int(4, true)
        end
      end
    end
  end
end