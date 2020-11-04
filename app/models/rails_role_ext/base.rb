module RailsRoleExt::Base

  def has_role?(business:, namespace:, controller:, action:, params: {})
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

  def any_taxon?(*any_taxons)
    (any_taxons.map(&:to_s) & taxon_codes).present?
  end

end
