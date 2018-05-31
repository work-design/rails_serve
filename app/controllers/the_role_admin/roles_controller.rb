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
    new_ids = rule_ids_params.fetch('rule_ids', []).reject(&:blank?).map { |i| i.to_i }
    if params[:govern_taxon_id]
      govern_taxon = GovernTaxon.find(params[:govern_taxon_id])
      present_ids = govern_taxon.rule_ids & @role.rule_ids

      add_ids = new_ids - present_ids
      remove_ids = present_ids - new_ids
    else
      present_ids = Rule.without_taxon.pluck(:id) & @role.rule_ids

      add_ids = new_ids - present_ids
      remove_ids = present_ids - new_ids
    end

    @role.rule_ids += add_ids if add_ids
    @role.rule_ids -= remove_ids if remove_ids
    @role.assign_attributes role_params
    if @role.save
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
    params.fetch(:role, {}).permit(
      :name,
      :description
    )
  end

  def rule_ids_params
    params.fetch(:role, {}).permit(rule_ids: [])
  end

  def set_role
    @role = Role.find params[:id]
  end

end
