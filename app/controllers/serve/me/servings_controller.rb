module Serve
  class Me::ServingsController < Me::BaseController
    before_action :set_serving, only: [:qrcode, :start, :finish]

    def qrcode

    end

    def start
      @serving.member = current_member
      @serving.start_at = Time.current
      @serving.save
    end

    def finish
      @serving.finish_at = Time.current
      @serving.save
    end

    private
    def set_serving
      @serving = Serving.find params[:id]
    end

  end
end
