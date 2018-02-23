lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_role/version'

Gem::Specification.new do |s|
  s.name = 'the_role'
  s.version = TheRole::VERSION
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.summary = 'The Role'
  s.description = 'Management panel for TheRole on Semantic-UI'
  s.homepage = 'https://github.com/yigexiangfa/the_role'
  s.license = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|s|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '>= 4.2'
  s.add_dependency 'acts_as_list'
end
