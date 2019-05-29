class Role::WhoRolesController < Role::BaseController
  before_action :set_who, only: [:show, :edit, :update]

  def show

  end

  def edit
    @roles = Role.visible.where(who_type: [params[:who_type], nil])
  end

  def update
    if @who.class.column_names.include? 'cached_role_ids'
      @who.update cached_role_ids: who_params[:role_ids]
    else
      @who.update who_params
    end
  end

  private
  def set_who
    @who = params[:who_type].safe_constantize.find params[:who_id]
  end

  def who_params
    params.fetch(:who, {}).permit(
      role_ids: []
    )
  end

end
