Gem::Specification.new do |s|
  s.name = 'rails_role'
  s.version = '1.0.3'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.summary = 'Rails Role'
  s.description = 'Role Management with Fully UI'
  s.homepage = 'https://github.com/work-design/rails_role'
  s.license = 'MIT'

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

  s.add_dependency 'rails_com', '~> 1.2'
end
