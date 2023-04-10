# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pronto/rails_data_schema/version'

Gem::Specification.new do |spec|
  spec.name          = "pronto-rails_data_schema"
  spec.version       = Pronto::RailsDataSchemaVersion::VERSION
  spec.authors       = ["mbajur"]
  spec.email         = ["mbajur@gmail.com"]

  spec.summary       = %q{Pronto runner for detection of Rails data-migrate
    schema changes.}
  spec.description   = %q{Detects migration files and checks for changes in
    data_schema.rb file}
  spec.homepage      = "https://github.com/mbajur/pronto-rails_data_schema"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency 'pronto', '~> 0.11.0 '
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
end
