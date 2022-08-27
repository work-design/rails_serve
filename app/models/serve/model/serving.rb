module Serve
  module Model::Serving
    extend ActiveSupport::Concern

    included do
      attribute :start_at, :datetime
      attribute :finish_at, :datetime
      attribute :estimate_finish_at, :datetime

      belongs_to :service
      belongs_to :server, optional: true
      belongs_to :member, class_name: 'Org::Member', optional: true
      belongs_to :wallet_payment, class_name: 'Trade::WalletPayment', optional: true
      belongs_to :item, class_name: 'Trade::Item'

      after_save_commit :send_notice, if: -> { (saved_changes.keys & ['member_id', 'start_at', 'finish_at']).present? }
    end

    def sync_from

    end

    def enter_url
      Rails.application.routes.url_for(controller: 'serve/servings', action: 'qrcode', id: self.id, host: item.organ.host)
    end

    def qrcode_enter_png
      QrcodeHelper.code_png(enter_url, border_modules: 0, fill: 'pink')
    end

    def qrcode_enter_url
      QrcodeHelper.data_url(enter_url)
    end

    def send_notice
      broadcast_action_to(
        self,
        action: :update,
        target: "serving_#{id}",
        partial: 'serve/my/servings/_index/serving_preview',
        locals: { model: self }
      )
    end

  end
end
