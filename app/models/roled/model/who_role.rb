module Roled
  module Model::WhoRole
    extend ActiveSupport::Concern

    included do
      belongs_to :who, polymorphic: true
      belongs_to :role

      has_many :role_rule, foreign_key: :role_id, primary_key: :role_id
    end

  end
end
