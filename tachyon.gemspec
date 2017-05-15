# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tachyon/version'

Gem::Specification.new do |spec|
  spec.name          = "tachyon"
  spec.version       = Tachyon::VERSION
  spec.authors       = ["Aaron Gough"]
  spec.email         = ["aaron@aarongough.com"]

  spec.summary       = %q{Create records in a DB managed by ActiveRecord as fast as possible.}
  spec.description   = %q{Create records in a DB managed by ActiveRecord as fast as possible.}
  spec.homepage      = "https://github.com/aarongough/tachyon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "activerecord", "~> 5.1.1"
  spec.add_development_dependency "activesupport", "~> 5.1.1"
  spec.add_development_dependency "sqlite3"
end
