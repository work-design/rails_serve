class Admin::WhosController < Admin::BaseController
  before_action :set_who, only: [:show, :edit, :update, :destroy]

  def index
    @whos = Who.all
  end

  def new
    @who = Who.new
  end

  def create
    @who = Who.new(who_params)

    respond_to do |format|
      if @who.save
        format.html { redirect_to admin_whos_url, notice: 'Who was successfully created.' }
        format.json { render :show, status: :created, location: @who }
      else
        format.html { render :new }
        format.json { render json: @who.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @who.update(who_params)
        format.html { redirect_to admin_whos_url, notice: 'Who was successfully updated.' }
        format.json { render :show, status: :ok, location: @who }
      else
        format.html { render :edit }
        format.json { render json: @who.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @who.destroy
    respond_to do |format|
      format.html { redirect_to admin_whos_url, notice: 'Who was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_who
    @who = Who.find(params[:id])
  end

  def who_params
    params.fetch(:who, {}).permit(:name, role_ids: [])
  end

end
