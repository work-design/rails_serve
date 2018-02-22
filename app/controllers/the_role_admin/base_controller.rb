class TheRoleAdmin::BaseController < TheRole.config.admin_class.constantize
  default_form_builder 'TheRoleAdminFormBuilder'


end
