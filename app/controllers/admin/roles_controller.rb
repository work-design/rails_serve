class Admin::RolesController < Admin::BaseController
  before_action :set_role, only: [:show, :edit, :update, :destroy, :change, :role_export]

  def index
    @roles = Role.order('created_at ASC')
  end

  def new
    @role = Role.new
  end

  def edit
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

  def update
    if @role.update role_params
      flash[:notice] = t('.role_updated')
      redirect_to admin_roles_url
    else
      render action: :edit
    end
  end

  def change
    if @role.update!(role_params)
      flash[:notice] = t('.role_updated')
      redirect_to admin_roles_url
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
                         :title,
                         :description,
                         :the_role,
                         :based_on_role)
  end

  def set_role
    @role = Role.find params[:id]
  end

end
