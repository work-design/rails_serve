class TheRoleAdmin::WhoRolesController < TheRoleAdmin::BaseController
  before_action :set_who, only: [:index, :new, :create]

  def index
    @roles = @who.roles
  end

  def new
    @who_role = WhoRole.new
  end

  def create
    @who_role = WhoRole.new(who_params)

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
    @who = params[:who_type].safe_constantize.find params[:who_id]
  end

  def who_params
    params.fetch(:who, {}).permit(:name, role_ids: [])
  end

end
