# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xmpp_simple/version'

Gem::Specification.new do |spec|
  spec.name          = 'xmpp_simple'
  spec.version       = XMPPSimple::VERSION
  spec.authors       = ['l3akage']
  spec.email         = ['info@l3akage.de']
  spec.summary       = 'Simple XMPP implementation'
  spec.description   = 'Simple XMPP implementation'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_dependency 'celluloid-io'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'ox'
end
