module Serve
  module Model::Service
    extend ActiveSupport::Concern

    included do
      attribute :name, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :servers, dependent: :destroy
      has_many :members, through: :servers
    end

  end
end
