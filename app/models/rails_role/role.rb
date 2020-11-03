module RailsRole::Role
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :description, :string
    attribute :visible, :boolean, default: false
    attribute :who_types, :string, array: true

    has_many :who_roles, dependent: :destroy
    has_many :role_rules, dependent: :destroy, inverse_of: :role
    has_many :rules, through: :role_rules, dependent: :destroy
    has_many :governs, ->{ distinct }, through: :role_rules
    has_many :busynesses, -> { distinct }, through: :role_rules
    has_many :role_types, dependent: :delete_all

    scope :visible, -> { where(visible: true) }

    validates :name, presence: true

    #before_save :sync_who_types
  end

  def has_role?(business:, namespace: nil, controller: nil, action: nil, params: {})
    if role_rules.disabled.where(
      business_identifier: business,
      namespace_identifier: namespace,
      controller_identifier: controller,
      action_name: action
    ).exists?
      return false
    end

    role_rules.enabled.where(
      business_identifier: business,
      namespace_identifier: [namespace, nil],
      controller_identifier: [controller, nil],
      action_name: [action, nil],
    ).exists?
  end

  def sync_who_types
    who_types.exists?(who)
  end

end
