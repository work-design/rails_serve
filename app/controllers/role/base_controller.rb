class Role::BaseController < RailsRole.config.app_controller.constantize
  before_action :require_role

end
