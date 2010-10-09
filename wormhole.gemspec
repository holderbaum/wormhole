$:.unshift('lib')
require 'wormhole'

Gem::Specification.new do |s|
  s.author = "Jakob Holderbaum"
  s.email = 'rubygems@techfolio.de'
  s.homepage = "http://techfolio.de"

  s.name = 'wormhole'
  s.version = Wormhole::VERSION::STRING
  s.platform = Gem::Platform::RUBY
  s.summary = "imagine a world, with wormholes between the rails-o-verse and the javascript-o-verse"
  s.description = "Wormhole provides a semantic and clean way to distribute dynamic informations on request-level" + 
      "to every javascript snippet in the current view."

  s.files = Dir[ 'lib/**/*', 'spec/**/*']
  s.has_rdoc = false
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('rspec', '~> 1.3.0')
  s.add_dependency('json', '>= 0')
end
