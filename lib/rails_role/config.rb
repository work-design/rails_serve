module RailsRole
  include ActiveSupport::Configurable

  configure do |config|
    config.default_admin_accounts = []
    config.debug = false
    config.default_return_path = '/board'
  end

end
