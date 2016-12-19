class Admin::RulesController < Admin::BaseController
  before_action :set_section
  before_action :set_rule, only: [:show, :edit, :update, :move_higher, :move_lower, :destroy]

  def index
    @rules = Rule.all
  end

  def show
  end

  def new
    @rule = @section.rules.build
  end

  def edit
  end

  def create
    @rule = @section.rules.build(rule_params)

    respond_to do |format|
      if @rule.save
        format.html { redirect_to admin_sections_url, notice: 'Rule was successfully created.' }
        format.json { render :show, status: :created, location: @rule }
      else
        format.html { render :new }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def sync
    controller = (@section.code + '_controller').camelize.safe_constantize
    if controller
      all_actions = (controller.instance_methods(false) - [:new]).map(&:to_s)
      section_rules = @section.rules.pluck(:code)

      (all_actions - section_rules).each do |la|
        @section.rules.create(code: la)
      end

      invalid_rules = (section_rules - all_actions) - ['admin', 'read', 'write']
      invalid_rules.each do |la|
        @section.rules.find_by(code: la).destroy
      end
    end

    redirect_to admin_sections_url
  end

  def update
    respond_to do |format|
      if @rule.update(rule_params)
        format.html { redirect_to admin_sections_url, notice: 'Rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @rule }
      else
        format.html { render :edit }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def move_higher
    @rule.move_higher
    redirect_to admin_sections_url(params.to_h)
  end

  def move_lower
    @rule.move_lower
    redirect_to admin_sections_url(params.to_h)
  end

  def destroy
    @rule.destroy
    respond_to do |format|
      format.html { redirect_to admin_sections_url, notice: 'Rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_section
    @section = Section.find params[:section_id]
  end

  def set_rule
    @rule = Rule.find(params[:id])
  end

  def rule_params
    params.fetch(:rule, {}).permit(:code, :name, :params, :position)
  end

end
