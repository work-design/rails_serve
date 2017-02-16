class Admin::RulesController < Admin::BaseController
  before_action :set_section
  before_action :set_rule, only: [:show, :roles, :edit, :update, :move_higher, :move_lower, :destroy]

  def index
    @rules = Rule.all
  end

  def create
    @rule = @section.rules.build(rule_params)

    respond_to do |format|
      if @rule.save
        format.html { redirect_to admin_sections_url(anchor: "tr_#{@section.id}"), notice: 'Rule was successfully created.' }
        format.json { render :show, status: :created, location: @rule }
      else
        format.html { render :new }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def sync
    all_actions = ['admin', 'read'] + RailsCom::Routes.actions(@section.code)
    section_rules = @section.rules.pluck(:code)

    (all_actions - section_rules).each do |la|
      @section.rules.create(code: la)
    end

    invalid_rules = (section_rules - all_actions)
    invalid_rules.each do |la|
      @section.rules.find_by(code: la).destroy
    end

    redirect_to admin_sections_url(anchor: "tr_#{@section.id}")
  end

  def new
    @rule = @section.rules.build
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
        format.html { redirect_to admin_sections_url(anchor: "tr_#{@section.id}"), notice: 'Rule was successfully updated.' }
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
      format.html { redirect_to admin_sections_url(anchor: "tr_#{@section.id}"), notice: 'Rule was successfully destroyed.' }
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
