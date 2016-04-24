# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xmpp_simple/version'

Gem::Specification.new do |spec|
  spec.name          = 'xmpp_simple'
  spec.version       = XMPPSimple::VERSION
  spec.authors       = ['l3akage']
  spec.email         = ['info@l3akage.de']

  spec.homepage      = 'https://github.com/l3akage/xmpp_simple'
  spec.summary       = 'Simple XMPP implementation'
  spec.description   = 'A simle xmpp implementation using celluloid'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting "allowed_push_host", or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'TODO: Set to "http://mygemserver.com"'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'celluloid-io', '~> 0.17.3'
  spec.add_dependency 'nokogiri', '~> 1.6'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 11.1'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'equivalent-xml', '~> 0.6'
  spec.add_development_dependency 'guard', '~> 2.13'
  spec.add_development_dependency 'guard-rspec', '~> 4.6'
  spec.add_development_dependency 'simplecov', '~> 0.11'
end
