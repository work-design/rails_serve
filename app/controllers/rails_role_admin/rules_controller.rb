class RailsRoleAdmin::RulesController < RailsRoleAdmin::BaseController
  before_action :set_govern
  before_action :set_rule, only: [:show, :roles, :edit, :update, :move_higher, :move_lower, :destroy]

  def create
    @rule = @govern.rules.build(rule_params)

    respond_to do |format|
      if @rule.save
        format.html { redirect_to admin_governs_url(anchor: "tr_#{@govern.id}"), notice: 'Rule was successfully created.' }
        format.json { render :show, status: :created, location: @rule }
      else
        format.html { render :new }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def sync
    @govern.sync_rules

    redirect_to admin_governs_url(anchor: "tr_#{@govern.id}")
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
    respond_to do |format|
      if @rule.update(rule_params)
        format.html { redirect_to admin_governs_url(anchor: "tr_#{@govern.id}"), notice: 'Rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @rule }
      else
        format.html { render :edit }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def move_higher
    @rule.move_higher
    redirect_to admin_governs_url(params.to_h)
  end

  def move_lower
    @rule.move_lower
    redirect_to admin_governs_url(params.to_h)
  end

  def destroy
    @rule.destroy
    respond_to do |format|
      format.html { redirect_to admin_governs_url(anchor: "tr_#{@govern.id}"), notice: 'Rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_govern
    @govern = Govern.find params[:govern_id]
  end

  def set_rule
    @rule = Rule.find(params[:id])
  end

  def rule_params
    params.fetch(:rule, {}).permit(:code, :name, :params, :position)
  end

end
