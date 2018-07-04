
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "touhou/score/version"

Gem::Specification.new do |spec|
  spec.name          = "touhou-score"
  spec.version       = Touhou::Score::VERSION
  spec.authors       = ["mktoho"]
  spec.email         = ["makoto_16n1200102@nnn.ed.jp"]

  spec.summary       = %q{The library for reading the score file of the Touhou project games.}
  spec.description   = %q{It is a library which loads the score file of the Touhou project games.}
  spec.homepage      = "https://github.com/mktoho12/touhou-score"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bin_utils"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.11"
end
