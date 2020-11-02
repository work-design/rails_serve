class Role::Panel::RolesController < Role::Panel::BaseController
  before_action :set_role, only: [:show, :overview, :edit, :update, :destroy]

  def index
    @roles = Role.order(created_at: :asc)
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new role_params

    unless @role.save
      render :new, locals: { model: @role }, status: :unprocessable_entity
    end
  end

  def show
    q_params = {}
    q_params.merge! params.permit(:govern_taxon_id)

    @governs = Govern.includes(:rules).default_where(q_params)
    @busynesses = Busyness.all
  end

  def overview
    @taxon_ids = @role.governs.unscope(:order).uniq
  end

  def edit
  end

  def update
    new_ids = rule_ids_params.fetch('rule_ids', []).reject(&:blank?).map(&:to_i)
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

    unless @role.save
      render :edit, locals: { model: @role }, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy
  end

  private
  def role_params
    p = params.fetch(:role, {}).permit(
      :name,
      :code,
      :description,
      :visible,
      who_types: []
    )
    p.fetch(:who_types, []).reject!(&:blank?)
    p
  end

  def rule_ids_params
    params.fetch(:role, {}).permit(
      rule_ids: []
    )
  end

  def set_role
    @role = Role.find params[:id]
  end

end
