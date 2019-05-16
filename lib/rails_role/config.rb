module RailsRole
  include ActiveSupport::Configurable
  config_accessor :default_admin_emails

  configure do |config|
    config.default_admin_emails = []
    config.admin_controller = 'AdminController'
    config.ignore_controllers = []
  end

end
