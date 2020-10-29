class Role::Admin::BusynessesController < Role::Admin::BaseController
  before_action :set_busyness, only: [:show, :edit, :update, :destroy]

  def index
    @busynesses = Busyness.page(params[:page])
  end

  def new
    @busyness = Busyness.new
  end

  def create
    @busyness = Busyness.new(busyness_params)

    unless @busyness.save
      render :new, locals: { model: @busyness }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @busyness.assign_attributes(busyness_params)

    unless @busyness.save
      render :edit, locals: { model: @busyness }, status: :unprocessable_entity
    end
  end

  def destroy
    @busyness.destroy
  end

  private
  def set_busyness
    @busyness = Busyness.find(params[:id])
  end

  def busyness_params
    params.fetch(:busyness, {}).permit(
      :name,
      :identifier
    )
  end

end
