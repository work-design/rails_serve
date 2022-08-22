module Serve
  class Admin::ServicesController < Admin::BaseController
    before_action :set_service, only: [:show, :edit, :wallet, :update_wallet, :update, :destroy, :actions]

    def wallet
      @wallet_templates = Trade::WalletTemplate.default_where(default_params)
    end

    def update_wallet
      @service.wallet_price = wallet_price_params
      @service.save
    end

    private
    def set_service
      @service = Service.find params[:id]
    end

    def wallet_price_params
      r = {}

      params.dig(:service, :wallet_price).each do |_, v|
        r.merge! v[:code] => v[:price]
      end

      r
    end
  end
end
