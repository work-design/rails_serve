class Admin::RulesController < Admin::BaseController
  before_action :set_rule, only: [:show, :edit, :update, :destroy]

  def index
    @rules = Rule.all
  end

  def show
  end

  def new
    @rule = Rule.new
  end

  def edit
  end

  def create
    @rule = Rule.new(rule_params)

    respond_to do |format|
      if @rule.save
        format.html { redirect_to admin_rules_url, notice: 'Rule was successfully created.' }
        format.json { render :show, status: :created, location: @rule }
      else
        format.html { render :new }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @rule.update(rule_params)
        format.html { redirect_to admin_rules_url, notice: 'Rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @rule }
      else
        format.html { render :edit }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rule.destroy
    respond_to do |format|
      format.html { redirect_to admin_rules_url, notice: 'Rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_rule
    @rule = Rule.find(params[:id])
  end

  def rule_params
    params.fetch(:rule, {}).permit(:code, :name, :section_id)
  end


end
