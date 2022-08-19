module Serve
  module Model::Service
    extend ActiveSupport::Concern

    included do
      attribute :name, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :servers, dependent: :destroy
      has_many :members, through: :servers
      has_many :servings
    end

    def order_paid(item)
      rest = item.number - item.servings.count
      rest.times do
        servings.build(item_id: item.id)
      end
      save
    end

  end
end
