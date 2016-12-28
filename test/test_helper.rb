ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../test/dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'
require 'minitest/mock'

ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end
