module Serve
  class Me::ServingsController < Me::BaseController
    before_action :set_serving, only: [:qrcode, :claim]

    def qrcode

    end

    def claim
      @serving.member = current_member
      @serving.save
    end

    private
    def set_serving
      @serving = Serving.find params[:id]
    end

  end
end
