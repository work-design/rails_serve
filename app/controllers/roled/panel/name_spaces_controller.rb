module Roled
  class Panel::NameSpacesController < Panel::BaseController
    before_action :set_name_space, only: [:show, :edit, :update, :destroy]

    def index
      @name_spaces = NameSpace.order(id: :asc).page(params[:page])
    end

    def sync
      NameSpace.sync
    end

    def show
    end

    def edit
    end

    def update
      @name_space.assign_attributes(name_space_params)

      unless @name_space.save
        render :edit, locals: { model: @name_space }, status: :unprocessable_entity
      end
    end

    private
    def set_name_space
      @name_space = NameSpace.find(params[:id])
    end

    def name_space_params
      params.fetch(:name_space, {}).permit(
        :name,
        :identifier,
        :verify_organ,
        :verify_member,
        :verify_user
      )
    end

  end
end
