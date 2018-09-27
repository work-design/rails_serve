$:.push File.expand_path('lib', __dir__)
require 'rails_role/version'

Gem::Specification.new do |s|
  s.name = 'rails_role'
  s.version = RailsRole::VERSION
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.summary = 'Rails Role'
  s.description = 'Management panel for RailsRole on Semantic-UI'
  s.homepage = 'https://github.com/yougexiangfa/rails_role'
  s.license = 'LGPL-3.0'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'Rakefile',
    'LICENSE',
    'README.md'
  ]
  s.test_files = Dir[
    'test/**/*'
  ]
  s.require_paths = ['lib']

  s.add_dependency 'rails', '>= 5.0', '<= 6.0'
  s.add_dependency 'acts_as_list', '~> 0.9'
  s.add_dependency 'rails_com', '~> 1.2'
end
