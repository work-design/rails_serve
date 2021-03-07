module Roled
  module Model::RoleRule
    extend ActiveSupport::Concern

    included do
      attribute :business_identifier, :string, default: ''
      attribute :namespace_identifier, :string, default: ''
      attribute :controller_path, :string
      attribute :action_name, :string
      attribute :params_name, :string
      attribute :params_identifier, :string

      belongs_to :role, inverse_of: :role_rules
      belongs_to :busyness, foreign_key: :business_identifier, primary_key: :identifier, optional: true
      belongs_to :name_space, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
      belongs_to :govern, foreign_key: :controller_path, primary_key: :controller_path, optional: true
      belongs_to :rule
    end

  end
end
