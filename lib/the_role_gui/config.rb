require 'active_support/configurable'

module TheAuth
  include ActiveSupport::Configurable
  config_accessor :layout,
                  :destroy_strategy,
                  :default_user_class,
                  :access_denied_method,
                  :login_required_method,
                  :first_user_should_be_admin



  configure do |config|
    config.layout = :application
    config.first_user_should_be_admin = false
    config.access_denied_method = :access_denied
    config.destroy_strategy = :restrict_with_exception
  end

end