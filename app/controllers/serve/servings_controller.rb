module Serve
  class ServingsController < BaseController
    before_action :require_login
    before_action :set_serving, only: [:qrcode]

    def qrcode
      if current_user.organ_ids.include?(@serving.organ_id)
        redirect_to({ controller: 'serve/me/servings', action: 'qrcode', id: params[:id], host: @serving.service.organ.host }, allow_other_host: true)
      end
    end

    private
    def set_serving
      @serving = Serving.find params[:id]
    end

  end
end
