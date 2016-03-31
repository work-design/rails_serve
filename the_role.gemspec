lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_role/version'

Gem::Specification.new do |spec|
  spec.name = 'the_role'
  spec.version = TheRole::VERSION
  spec.authors = ['qinmingyuan']
  spec.email = ['mingyuan0715@foxmail.com']
  spec.summary = 'The Role GUI'
  spec.description = 'Management panel for TheRole on Semantic-UI'
  spec.homepage = 'https://github.com/yigexiangfa/the_role_gui'
  spec.license = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 4'
end
