class Role::Admin::BaseController < RailsRole.config.admin_controller.constantize
  include RailsRole::Application
  before_action :require_role

end
