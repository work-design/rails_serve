class TheRoleAdmin::RolesController < TheRoleAdmin::BaseController
  before_action :set_role, only: [:show, :overview, :edit, :update, :destroy]

  def index
    @roles = Role.order(created_at: :asc)
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
    if params[:govern_taxon_id]
      @govern_taxon = GovernTaxon.find params[:govern_taxon_id]
      @governs = @govern_taxon.governs.includes(:rules)
    else
      @governs = Govern.includes(:rules).without_taxon
    end
  end

  def overview

  end

  def edit
  end

  def update
    if @role.update role_params
      flash[:notice] = t('.role_updated')
      redirect_to admin_role_url(@role, govern_taxon_id: params[:govern_taxon_id])
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
