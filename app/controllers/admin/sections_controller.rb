class Admin::SectionsController < Admin::BaseController
  before_action :set_section, only: [:show, :edit, :update, :move_higher, :move_lower, :destroy]

  def index
    @sections = Section.includes(:rules).all
  end

  def show
  end

  def new
    @section = Section.new(section_taxon_id: params[:section_taxon_id])
    @options = SectionTaxon.select(:id, :name).all
  end

  def create
    @section = Section.new(section_params)

    respond_to do |format|
      if @section.save
        format.html { redirect_to admin_sections_url, notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html {
          @options = SectionTaxon.select(:id, :name).all
          render :new
        }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @options = SectionTaxon.select(:id, :name).all
  end

  def update
    @section.assign_attributes(section_params)
    respond_to do |format|
      if @section.save
        format.html { redirect_to admin_sections_url, notice: 'Section was successfully updated.' }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def move_higher
    @section.move_higher
    redirect_to admin_sections_url(params.to_h)
  end

  def move_lower
    @section.move_lower
    redirect_to admin_sections_url(params.to_h)
  end

  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to admin_sections_url, notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.fetch(:section, {}).permit(:code, :name, :position, :section_taxon_id)
  end

end
