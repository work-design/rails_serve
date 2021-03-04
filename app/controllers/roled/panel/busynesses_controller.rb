module Roled
  class Panel::BusynessesController < Panel::BaseController
    before_action :set_busyness, only: [:show, :edit, :update, :move_higher, :move_lower]

    def index
      @busynesses = Busyness.with_attached_logo.order(position: :asc).page(params[:page])
    end

    def sync
      Busyness.sync
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

    def move_higher
      @busyness.move_higher
    end

    def move_lower
      @busyness.move_lower
    end

    private
    def busyness_params
      params.fetch(:busyness, {}).permit(
        :name,
        :logo
      )
    end

    def set_busyness
      @busyness = Busyness.find(params[:id])
    end

  end
end
