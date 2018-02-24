class TheRoleAdmin::WhoRolesController < TheRoleAdmin::BaseController
  before_action :set_who, only: [:index]

  def index
  end

  private
  def set_who
    @who = params[:who_type].safe_constantize.find params[:who_id]
  end

end
