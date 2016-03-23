$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'transifex/version'

Gem::Specification.new do |s|
  s.name     = 'transifex-client'
  s.version  = ::Transifex::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron'

  s.description = s.summary = 'Ruby wrapper around the Transifex REST API.'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'delegate_it', '~> 1.0'
  s.add_dependency 'faraday', '~> 0.8'
  s.add_dependency 'faraday_middleware', '~> 0.9'
  s.add_dependency 'hashie', '~> 3.0'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", 'Gemfile', 'History.txt', 'README.md', 'Rakefile', 'transifex-client.gemspec']
end
