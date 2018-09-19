module RailsRole
  include ActiveSupport::Configurable
  config_accessor :access_denied_method, :default_admin_emails

  configure do |config|
    config.access_denied_method = nil
    config.default_admin_emails = []
    config.admin_class = 'Admin::BaseController'
    config.ignore_controllers = []
  end

end
