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
    end

    def sync_from

    end

  end
end
