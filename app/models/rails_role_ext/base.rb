module RailsRoleExt::Base

  def has_role?(business_identifier, namespace_identifier, controller_identifier, action_name, params)
    if respond_to?(:admin?) && admin?
      return true
    end

    rule = RoleRule.where(
      role_id: role_ids,
      business_identifier: [business_identifier, nil],
      namespace_identifier: [namespace_identifier, nil],
      controller_identifier: [controller_identifier, nil],
      action_name: [action_name, nil],
      enabled: true
    )

    if rule.blank?
      verbs = RailsCom::Routes.verbs govern_name, rule_name
      if verbs.include?('GET') && !rule_name.start_with?('new', 'edit')
        rule = rails_role[govern_name]['read']
      end
    end

    if rule.is_a?(Array) && params.present?
      rule.include? params.to_s
    else
      rule
    end
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
