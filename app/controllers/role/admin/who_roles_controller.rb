class Role::Admin::WhoRolesController < Role::Admin::BaseController
  before_action :set_who, only: [:show, :edit, :update]

  def show

  end

  def edit

  end

  def update
    @who.update who_params
  end

  private
  def set_who
    @who = params[:who_type].safe_constantize.find params[:who_id]
  end

  def who_params
    params.fetch(:who, {}).permit(role_ids: [])
  end

end
