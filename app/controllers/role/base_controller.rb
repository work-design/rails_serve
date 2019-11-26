class Role::BaseController < RailsRole.config.app_controller.constantize
  include RailsRole::Application
  before_action :require_role

end
