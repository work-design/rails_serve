module Serve
  class Admin::ServersController < Admin::BaseController
    before_action :set_service
    before_action :set_new_server, only: [:new, :create]
    before_action :set_members, only: [:new, :create, :edit, :update]

    private
    def set_service
      @service = Service.find params[:service_id]
    end

    def set_new_server
      @server = @service.servers.build(server_params)
    end

    def set_members
      @members = Org::Member.default_where(default_params)
    end

    def server_params
      params.fetch(:server, {}).permit(
        :name,
        :member_id
      )
    end

  end
end
