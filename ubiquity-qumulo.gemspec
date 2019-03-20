# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ubiquity/qumulo/version'

Gem::Specification.new do |spec|
  spec.name          = 'ubiquity-qumulo'
  spec.version       = Ubiquity::Qumulo::VERSION
  spec.authors       = ['John Whitson']
  spec.email         = ['john.whitson@gmail.com']

  spec.summary       = %q{A utility library for interacting with the Qumulo Appliance API}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/XPlatform-Consulting/ubiquity-qumulo"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end
