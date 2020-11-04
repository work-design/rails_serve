module RailsRole::User
  extend ActiveSupport::Concern

  included do
    attribute :cached_role_ids, :integer, array: true

    has_many :who_roles, as: :who, dependent: :destroy
    has_many :roles, through: :who_roles

    after_save :sync_to_role_ids, if: ->{ saved_change_to_cached_role_ids? }
  end

  def admin?
    if respond_to?(:account_identities) && (RailsRole.config.default_admin_accounts & account_identities).length > 0
      true
    elsif respond_to?(:identity) && RailsRole.config.default_admin_accounts.include?(identity)
      true
    elsif defined? super
      super
    end
  end

  def role_hash
    result = {}
    roles.each do |role|
      result.deep_merge! role.role_hash
    end

    result
  end

  def has_role?(business: 'application', namespace: 'application', controller:, action:, params: {})
    if respond_to?(:admin?) && admin?
      return true
    end

    options = [business.to_s, namespace.to_s, controller.to_s, action.to_s].take_while(&:present?)
    return false if options.blank?
    role_hash.dig(*options).present?
  end

  def any_role?(*any_roles, **roles_hash)
    if respond_to?(:admin?) && admin?
      return true
    end

    if (any_roles.map(&:to_s) & rails_role.keys).present?
      return true
    end

    roles_hash.stringify_keys!
    roles_hash.slice(*rails_role.keys).each do |govern, rules|
      h_keys = rails_role[govern].select { |i| i }.keys
      rules = Array(rules).map(&:to_s)
      return true if (h_keys & rules).present?
    end

    false
  end

  def sync_to_role_ids
    self.role_ids = cached_role_ids
  end

end
