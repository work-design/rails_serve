class Role::Panel::BusynessesController < Role::Panel::BaseController
  before_action :set_busyness, only: [:show, :move_higher, :move_lower]

  def index
    @busynesses = Busyness.page(params[:page])
  end

  def sync
    Busyness.sync
  end

  def show
  end

  def move_higher
    @busyness.move_higher
  end

  def move_lower
    @busyness.move_lower
  end

  private
  def set_busyness
    @busyness = Busyness.find(params[:id])
  end

end
