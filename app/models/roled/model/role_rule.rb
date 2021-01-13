module Roled
  module Model::RoleRule
    extend ActiveSupport::Concern

    included do
      attribute :business_identifier, :string
      attribute :namespace_identifier, :string
      attribute :controller_path, :string
      attribute :controller_name, :string
      attribute :action_name, :string
      attribute :params_name, :string
      attribute :params_identifier, :string

      belongs_to :role
      belongs_to :busyness, foreign_key: :business_identifier, primary_key: :identifier, optional: true
      belongs_to :name_space, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
      belongs_to :govern, foreign_key: :controller_name, primary_key: :controller_name, optional: true
      belongs_to :rule, ->(o){ where(business_identifier: o.business_identifier, namespace_identifier: o.namespace_identifier, controller_name: o.controller_name) }, foreign_key: :action_name, primary_key: :action_name, optional: true
    end

  end
end
