class Role::Admin::BaseController < RailsRole.config.admin_controller.constantize

  if whether_filter(:support_organ)
    skip_before_action :support_organ
  end

end
