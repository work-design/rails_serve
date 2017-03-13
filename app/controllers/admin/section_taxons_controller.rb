class Admin::SectionTaxonsController < Admin::BaseController
  before_action :set_section_taxon, only: [:edit, :update, :destroy]

  def new
    @section_taxon = SectionTaxon.new
  end

  def edit
  end

  def create
    @section_taxon = SectionTaxon.new(section_taxon_params)

    if @section_taxon.save
      redirect_to params[:return_to], notice: 'Section taxon 创建成功。'
    else
      render action: 'new'
    end
  end

  def update
    if @section_taxon.update(section_taxon_params)
      redirect_to params[:return_to], notice: 'Section taxon 更新成功。'
    else
      render action: 'edit'
    end
  end

  def destroy
    @section_taxon.destroy
    redirect_to section_taxons_path, notice: '删除成功!'
  end

  private
  def set_section_taxon
    @section_taxon = SectionTaxon.find(params[:id])
  end

  def section_taxon_params
    params.fetch(:section_taxon, {}).permit(:name)
  end

end
