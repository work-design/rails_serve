class Role::Admin::GovernTaxonsController < Role::Admin::BaseController
  before_action :set_govern_taxon, only: [:edit, :update, :destroy]

  def index
    @govern_taxons = GovernTaxon.page(params[:page])
  end

  def new
    @govern_taxon = GovernTaxon.new
  end

  def create
    @govern_taxon = GovernTaxon.new(govern_taxon_params)

    if @govern_taxon.save
      redirect_to params[:return_to] || admin_governs_url
    else
      render action: 'new'
    end
  end

  def sync
    GovernTaxon.sync_modules

    redirect_to admin_govern_taxons_url
  end

  def edit
  end

  def update
    if @govern_taxon.update(govern_taxon_params)
      redirect_to admin_governs_url
    else
      render action: 'edit'
    end
  end

  def destroy
    @govern_taxon.destroy
    redirect_to admin_govern_taxons_path
  end

  private
  def set_govern_taxon
    @govern_taxon = GovernTaxon.find(params[:id])
  end

  def govern_taxon_params
    params.fetch(:govern_taxon, {}).permit(
      :name,
      :code,
      :position
    )
  end

end
