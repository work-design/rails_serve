Gem::Specification.new do |s|
  s.name = 'rails_serve'
  s.version = '0.0.1'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_serve'
  s.summary = 'Summary of RailsServe.'
  s.description = 'Description of RailsServe.'
  s.license = 'MIT'

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir[
      '{app,config,db,lib}/**/*',
      'LICENSE',
      'Rakefile',
      'README.md'
    ]
  end

  s.add_dependency 'rails', '>= 7.0.3.1'
end
