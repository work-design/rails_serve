module Roled
  module Model::WhoRole
    extend ActiveSupport::Concern

    included do
      attribute :type, :string

      has_many :role_rules, foreign_key: :role_id, primary_key: :role_id
    end

  end
end
