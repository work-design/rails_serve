class Role::Panel::RolesController < Role::Panel::BaseController
  before_action :set_role, only: [
    :show, :overview, :edit, :update, :destroy,
    :namespaces, :governs, :rules,
    :business_on, :business_off, :namespace_on, :namespace_off, :govern_on, :govern_off, :rule_on, :rule_off
  ]

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

  def namespaces
    @busyness = Busyness.find_by identifier: params[:business_identifier]
    identifiers = Govern.unscope(:order).select(:namespace_identifier).where(business_identifier: params[:business_identifier]).distinct.pluck(:namespace_identifier)
    @name_spaces = NameSpace.where(identifier: identifiers)
  end

  def governs
    q_params = {}
    q_params.merge! params.permit(:business_identifier, :namespace_identifier)

    @governs = Govern.default_where(q_params)
  end

  def rules
    q_params = {}
    q_params.merge! params.permit(:controller_identifier)

    @rules = Rule.default_where(q_params)
  end

  def overview
    @taxon_ids = @role.governs.unscope(:order).uniq
  end

  def edit
  end

  def business_on
    busyness = Busyness.find_by identifier: params[:business_identifier]
    @role.role_hash.merge! busyness.role_hash
    @role.save
  end

  def business_off
    @role.role_hash.delete params[:business_identifier]
    @role.save
  end

  def namespace_off
    @role.role_hash[params[:business_identifier]].delete(params[:namespace_identifier])
    @role.save
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
