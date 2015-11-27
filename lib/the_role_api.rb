require 'the_role_api/hash'
require 'the_role_api/config'
require 'the_role_api/version'

require 'multi_json'
require 'the_string_to_slug'

module TheRole
  module Api; end

  class << self
    def create_admin!
      admin_role = ::Role.where(name: :admin).first_or_create!(
        name:        :admin,
        title:       "Role for admin",
        description: "This user can do anything"
      )
      admin_role.create_rule(:system, :administrator)
      admin_role.rule_on(:system, :administrator)
      admin_role
    end
  end

  class Engine < Rails::Engine
    # Right now I don't know why, but autoload_paths doesn't work here
    # Patch it, if you know how
    if Rails::VERSION::MAJOR == 3
      app = "#{ config.root }/app"
      require_dependency "#{ app }/controllers/concerns/the_role/controller.rb"
      %w[ base_methods role user ].each do |file|
        require_dependency "#{ app }/models/concerns/the_role/api/#{ file }.rb"
      end
    end

    if Rails::VERSION::MAJOR == 4
      config.autoload_paths << "#{ config.root }/app/models/concerns/**"
      config.autoload_paths << "#{ config.root }/app/controllers/concerns/**"
    end

    if Rails::VERSION::MAJOR == 5
      raise Exception.new("TheRole 3. Version for Rails 5 not tested yet")
    end

    initializer "the_role_precompile_hook", group: :all do |app|
      app.config.assets.precompile += %w(
        the_role_management_panel.js
        the_role_management_panel.css
      )
    end
  end
end

# ==========================================================================================
# Just info
# ==========================================================================================
#
# http://stackoverflow.com/questions/6279325/adding-to-rails-autoload-path-from-gem
# config.to_prepare do; end
#
# ==========================================================================================
#
# require 'the_role_api/active_record'
#
# if defined?(ActiveRecord::Base)
#   ActiveRecord::Base.extend TheRole::Api::ActiveRecord
# end
#
# ==========================================================================================
#
# A note on Decorators and Loading Code # http://guides.rubyonrails.org/engines.html
#
# config.to_prepare do
#   Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
#     require_dependency(c)
#   end
# end
#
# ==========================================================================================
