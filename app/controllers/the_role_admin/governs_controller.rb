class TheRoleAdmin::GovernsController < TheRoleAdmin::BaseController
  before_action :set_govern, only: [:show, :edit, :update, :move_higher, :move_lower, :destroy]

  def index
    if params[:govern_taxon_id]
      @govern_taxon = GovernTaxon.find params[:govern_taxon_id]
      @governs = @govern_taxon.governs.includes(:rules)
    else
      @governs = Govern.includes(:rules).without_taxon
    end
  end

  def show
  end

  def new
    @govern = Govern.new(govern_taxon_id: params[:govern_taxon_id])
    @options = GovernTaxon.select(:id, :name).all
  end

  def create
    @govern = Govern.new(govern_params)

    respond_to do |format|
      if @govern.save
        format.html { redirect_to admin_governs_url, notice: 'Govern was successfully created.' }
        format.json { render :show, status: :created, location: @govern }
      else
        format.html {
          @options = GovernTaxon.select(:id, :name).all
          render :new
        }
        format.json { render json: @govern.errors, status: :unprocessable_entity }
      end
    end
  end

  def sync
    ControllerGovern.sync_controllers

    redirect_to admin_governs_url
  end

  def edit
    @options = GovernTaxon.select(:id, :name).all
  end

  def update
    @govern.assign_attributes(govern_params)
    respond_to do |format|
      if @govern.save
        format.html { redirect_to admin_governs_url, notice: 'Govern was successfully updated.' }
        format.json { render :show, status: :ok, location: @govern }
      else
        format.html { render :edit }
        format.json { render json: @govern.errors, status: :unprocessable_entity }
      end
    end
  end

  def move_higher
    @govern.move_higher
    redirect_to admin_governs_url(params.to_h)
  end

  def move_lower
    @govern.move_lower
    redirect_to admin_governs_url(params.to_h)
  end

  def destroy
    @govern.destroy
    respond_to do |format|
      format.html { redirect_to admin_governs_url, notice: 'Govern was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_govern
    @govern = Govern.find(params[:id])
  end

  def govern_params
    params.fetch(:govern, {}).permit(:code, :name, :position, :govern_taxon_id)
  end

end
