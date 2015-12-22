# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stock_fighter/version'

Gem::Specification.new do |spec|
  spec.name          = "stock_fighter"
  spec.version       = StockFighter::VERSION
  spec.authors       = ["wendi"]
  spec.email         = ["ifyouseewendy@gmail.com"]

  spec.summary       = %q{Ruby API client for StockFighter.}
  spec.description   = %q{Ruby API client for StockFighter.}
  spec.homepage      = "https://github.com/ifyouseewendy/stock_fighter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.2'

  spec.add_dependency 'httparty', "~> 0.13"
  spec.add_dependency 'activesupport', "~> 4.2"
end
