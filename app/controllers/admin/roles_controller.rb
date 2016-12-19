class Admin::RolesController < Admin::BaseController
  before_action :set_role, only: [:show, :toggle, :whos, :edit, :update, :destroy, :delete_who, :change]

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

  def whos
    @whos = @role.whos.page(params[:page])
  end

  def edit
  end

  def update
    if @role.update role_params
      flash[:notice] = t('.role_updated')
      redirect_to admin_roles_url
    else
      render action: :edit
    end
  end

  def toggle
    rule = Rule.find params[:rule_id]

    if params[:toggle] == 'on'
      @role.role_rules.find_or_create_by(rule_id: params[:rule_id])
    else
      @role.rules.destroy(rule)
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

  def delete_who
    user = Who.find params[:who_id]
    @role.whos.delete(user)

    redirect_to whos_admin_role_url(@role)
  end

  private
  def role_params
    params[:role].permit(:name,
                         :description,
                         :the_role)
  end

  def set_role
    @role = Role.find params[:id]
  end

end
