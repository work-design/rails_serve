class Role::Admin::BaseController < RailsRole.config.admin_controller.constantize

  if whether_filter(:require_organ)
    skip_before_action :require_organ
  end

end
