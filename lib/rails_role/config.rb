module RailsRole
  include ActiveSupport::Configurable
  config_accessor :default_admin_emails

  configure do |config|
    config.app_controller = 'ApplicationController'
    config.admin_controller = 'AdminController'
    config.ignore_controllers = []
    config.default_admin_accounts = []
    config.default_return_path = '/my'
  end

end
