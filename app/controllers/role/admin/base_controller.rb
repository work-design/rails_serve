class Role::Admin::BaseController < AdminController
  include RailsRole::Application
  before_action :require_role

end unless defined? Role::Admin::BaseController
