module RailsRole::RoleRule
  extend ActiveSupport::Concern

  included do
    attribute :business_identifier, :string
    attribute :namespace_identifier, :string
    attribute :controller_identifier, :string
    attribute :action_name, :string
    attribute :params_name, :string
    attribute :params_identifier, :string
    attribute :enabled, :boolean, default: true

    belongs_to :role
    belongs_to :busyness, foreign_key: :business_identifier, primary_key: :identifier, optional: true
    belongs_to :name_space, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
    belongs_to :govern, foreign_key: :controller_identifier, primary_key: :identifier, optional: true
    belongs_to :rule, ->(o){ where(controller_identifier: o.controller_identifier) }, foreign_key: :action_name, primary_key: :action_name, optional: true

    enum status: {
      available: 'available',
      unavailable: 'unavailable'
    }, _default: 'available'

    scope :enabled, -> { where(enabled: true) }
    scope :disabled, -> { where(enabled: false) }
  end

end
