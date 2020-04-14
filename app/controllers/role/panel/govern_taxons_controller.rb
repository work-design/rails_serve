class Role::Panel::GovernTaxonsController < Role::Panel::BaseController
  before_action :set_govern_taxon, only: [:edit, :update, :destroy]

  def index
    @govern_taxons = GovernTaxon.roots.page(params[:page])
  end

  def new
    @govern_taxon = GovernTaxon.new
  end

  def create
    @govern_taxon = GovernTaxon.new(govern_taxon_params)

    unless @govern_taxon.save
      render :new, locals: { model: @govern_taxon }, status: :unprocessable_entity
    end
  end

  def sync
    GovernTaxon.sync_modules

    redirect_to admin_govern_taxons_url
  end

  def edit
  end

  def update
    @govern_taxon.assign_attributes(govern_taxon_params)

    unless @govern_taxon.save
      render :edit, locals: { model: @govern_taxon }, status: :unprocessable_entity
    end
  end

  def destroy
    @govern_taxon.destroy
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
