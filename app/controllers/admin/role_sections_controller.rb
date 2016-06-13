class Admin::RoleSectionsController < Admin::BaseController
  include TheRole::Admin
  before_action :set_role
  skip_before_action :verify_authenticity_token


  protected
  def set_role
    @role = Role.find params[:role_id]

    # TheRole: You have to define object for ownership check
    #for_ownership_check(@role)
  end

  def the_role_return_url(id)
    admin_role_url(id)
  end

end
