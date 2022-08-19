module Serve
  class ServicesController < BaseController

    def index
      @services = Service.default_where(default_params)
    end

  end
end
