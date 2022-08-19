module Serve
  class Admin::ServersController < Admin::BaseController
    before_action :set_service

    private
    def set_service
      @service = Service.find params[:service_id]
    end
  end
end
