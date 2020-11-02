module RailsRole::RoleRule
  extend ActiveSupport::Concern

  included do
    attribute :business_identifier, :string
    attribute :namespace_identifier, :string
    attribute :controller_identifier, :string
    attribute :action_identifier, :string, index: true
    attribute :action_name, :string
    attribute :params_name, :string
    attribute :params_identifier, :string
    attribute :enabled, :boolean, default: true

    belongs_to :role
    belongs_to :rule, foreign_key: :action_identifier, primary_key: :identifier, optional: true
    belongs_to :govern, foreign_key: :controller_identifier, primary_key: :identifier, optional: true

    enum status: {
      available: 'available',
      unavailable: 'unavailable'
    }, _default: 'available'
  end

end

