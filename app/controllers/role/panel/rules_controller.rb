class Role::Panel::RulesController < Role::Panel::BaseController
  before_action :set_govern
  before_action :set_rule, only: [:show, :roles, :edit, :update, :move_higher, :move_lower, :destroy]

  def create
    @rule = @govern.rules.build(rule_params)

    unless @rule.save
      render :new, locals: { model: @rule }, status: :unprocessable_entity
    end
  end

  def new
    @rule = @govern.rules.build
  end

  def show
  end

  def roles
    @roles = @rule.roles
  end

  def edit
  end

  def update
    @rule.assign_attributes(rule_params)


    unless @rule.save
      render :edit, locals: { model: @rule }, status: :unprocessable_entity
    end
  end

  def move_higher
    @rule.move_higher
  end

  def move_lower
    @rule.move_lower
  end

  def destroy
    @rule.destroy
  end

  private
  def set_govern
    @govern = Govern.find params[:govern_id]
  end

  def set_rule
    @rule = Rule.find(params[:id])
  end

  def rule_params
    params.fetch(:rule, {}).permit(
      :code,
      :name,
      :params,
      :position
    )
  end

end
