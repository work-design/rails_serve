module Serve
  module Model::Server
    extend ActiveSupport::Concern

    included do
      attribute :name, :string

      belongs_to :service
      belongs_to :member, class_name: 'Org::Member'
    end

  end
end
