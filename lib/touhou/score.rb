require "touhou/score/version"

Dir[File.expand_path('../score', __FILE__) << '/*.rb'].each do |file|
  require file
end

module Touhou
  module Score
    # Your code goes here...
  end
end
