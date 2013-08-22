# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qihu/version'

Gem::Specification.new do |spec|
  spec.name          = "qihu360"
  spec.version       = Qihu::VERSION
  spec.authors       = ["icyleaf"]
  spec.email         = ["icyleaf.cn@gmail.com"]
  spec.description   = %q{Qihu 360.cn OAuth2 & Dianjing(Advertising system) API wrapper}
  spec.summary       = %q{Qihu 360.cn OAuth2 & Dianjing API wrapper}
  spec.homepage      = "https://github.com/icyleaf/qihu360"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "oauth2", "~> 0.9.2"
  spec.add_dependency "multi_json", "~> 1.0"
  spec.add_dependency "multi_xml", "~> 0.5"
end
