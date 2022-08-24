module Serve
  class Admin::ServicesController < Admin::BaseController
    before_action :set_service, only: [
      :show, :edit, :update, :destroy, :actions,
      :wallet, :update_wallet, :card, :update_card
    ]

    def wallet
      @wallet_templates = Trade::WalletTemplate.default_where(default_params)
    end

    def update_wallet
      @service.wallet_price = wallet_price_params
      @service.save
    end

    def card
      @card_templates = Trade::CardTemplate.default_where(default_params)
    end

    def update_card
      @service.card_price = card_price_params
      @service.save
    end

    private
    def set_service
      @service = Service.find params[:id]
    end

    def wallet_price_params
      r = {}

      params.fetch(:service, {}).fetch(:wallet_price, {}).each do |_, v|
        r.merge! v[:code] => v[:price]
      end

      r
    end

    def card_price_params
      r = {}

      params.dig(:service, :card_price).each do |_, v|
        r.merge! v[:code] => v[:price]
      end

      r
    end
  end
end
