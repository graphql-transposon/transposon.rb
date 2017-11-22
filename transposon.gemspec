# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transposon/version'

Gem::Specification.new do |spec|
  spec.name          = 'transposon'
  spec.version       = Transposon::VERSION
  spec.authors       = ['Garen J. Torikian']
  spec.email         = ['gjtorikian@gmail.com']

  spec.summary       = 'Automagically generate a client from a GraphQL IDL file.'
  spec.homepage      = 'https://github.com/graphql-transposon/transposon.rb'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-github'
  spec.add_development_dependency 'pry', '~> 0.10'
end
