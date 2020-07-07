module RailsRole
  include ActiveSupport::Configurable

  configure do |config|
    config.ignore_controllers = []
    config.default_admin_accounts = []
    config.default_return_path = '/my'
  end

end
