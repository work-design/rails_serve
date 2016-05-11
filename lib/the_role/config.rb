module TheRole
  include ActiveSupport::Configurable
  config_accessor :layout,
                  :destroy_strategy,
                  :default_user_role,
                  :access_denied_method,
                  :login_required_method,
                  :default_admin_email

  configure do |config|
    config.layout = :application
    config.default_user_role = nil
    config.access_denied_method = nil
    config.login_required_method  = nil
    config.default_admin_email = nil
  end
end
