# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quivjek/version'

Gem::Specification.new do |spec|
  spec.name          = "quivjek"
  spec.version       = Quivjek::VERSION
  spec.authors       = ["Ben Bjurstrom"]
  spec.email         = ["ben@jelled.fake"]

  spec.summary       = "A Jekyll plugin for seamless publication of Quiver notebooks"
  spec.description   = "A Jekyll plugin that automatically copies a Quiver notebook to your Jekyll _posts folder whenever the jekyll build command runs. Quivjek also copies and properly links any images contained in a Quiver note to your Jekyll images folder."
  spec.homepage      = "https://github.com/benbjurstrom/quivjek"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "front_matter_parser", "0.1.1"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 12.0.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "jekyll", ">= 2.0"
end
