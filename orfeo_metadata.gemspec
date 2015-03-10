# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'orfeo_metadata/version'

Gem::Specification.new do |spec|
  spec.name          = "orfeo_metadata"
  spec.version       = OrfeoMetadata::VERSION
  spec.authors       = ["Lari Lampen"]
  spec.email         = ["lari.lampen@gmail.com"]

  spec.summary       = %q{Orfeo metadata store.}
  spec.description   = %q{A metadata model and a store for the associated values.}
  spec.homepage      = "https://github.com/larilampen/orfeo-metadata"
  spec.license       = "GPL-3.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
