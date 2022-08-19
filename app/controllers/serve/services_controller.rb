module Serve
  class ServicesController < BaseController
    before_action :set_cart

    def index
      @services = Service.default_where(default_params)
    end

    def set_cart
      @cart = current_carts.find_or_create_by(good_type: 'Serve::Service', aim: 'use')
    end

  end
end
