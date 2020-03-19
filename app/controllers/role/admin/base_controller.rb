class Role::Admin::BaseController < RailsRole.config.admin_controller.constantize

  def rails_role_user
    defined?(current_user) && current_user
  end

end
