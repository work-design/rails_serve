class Admin::RolesController < Admin::BaseController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def index
    @roles = Role.order('created_at ASC')
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new role_params

    if @role.save
      flash[:notice] = t('.role_created')
      redirect_to admin_roles_url
    else
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @role.update role_params
      flash[:notice] = t('.role_updated')
      redirect_to admin_role_url(@role)
    else
      render action: :edit
    end
  end

  def destroy
    @role.destroy
    flash[:notice] = t('.role_deleted')
    redirect_to admin_roles_url
  end

  private
  def role_params
    params[:role].permit(:name,
                         :description,
                         :the_role, rule_ids: [])
  end

  def set_role
    @role = Role.find params[:id]
  end

end
