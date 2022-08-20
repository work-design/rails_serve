module Serve
  class My::ServingsController < My::BaseController
    before_action :set_service

    def index
      @servings = @service.servings.where(item_id: params[:item_id])
    end

    private
    def set_service
      @service = Service.find params[:service_id]
    end

  end
end
