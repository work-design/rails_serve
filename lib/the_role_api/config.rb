module TheRole
  def self.configure(&block)
    yield @config ||= TheRole::Configuration.new
  end

  def self.config
    @config
  end

  # Configuration class
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :layout,
                    :destroy_strategy,
                    :default_user_role,
                    :access_denied_method,
                    :login_required_method,
                    :first_user_should_be_admin
  end

  configure do |config|
    config.layout = :application

    config.default_user_role          = nil
    config.access_denied_method       = nil
    config.login_required_method      = nil
    config.destroy_strategy           = nil
    config.first_user_should_be_admin = false
  end
end
