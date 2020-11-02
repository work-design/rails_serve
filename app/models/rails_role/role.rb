module RailsRole::Role
  extend ActiveSupport::Concern

  included do
    attribute :name, :string, null: false
    attribute :description, :string, limit: 1024
    attribute :visible, :boolean, default: false
    attribute :who_types, :string, array: true

    has_many :who_roles, dependent: :destroy
    has_many :role_rules, dependent: :destroy, inverse_of: :role
    has_many :rules, through: :role_rules, dependent: :destroy
    has_many :governs, ->{ distinct }, through: :role_rules
    has_many :busynesses, -> { distinct }, through: :role_rules
    has_many :role_types, dependent: :delete_all

    scope :visible, -> { where(visible: true) }

    #before_save :sync_who_types
  end

  def has_role?(business:, namespace:, controller:, action:, params:)
    role_rules.where(
      business_identifier: [business, nil],
      namespace_identifier: [namespace, nil],
      controller_identifier: [controller, nil],
      action_name: [action, nil],
      enabled: true
    ).exists?
  end

  def sync_who_types
    who_types.exists?(who)
  end

end
