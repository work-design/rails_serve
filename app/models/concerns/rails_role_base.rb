module RailsRoleBase

  def has_role?(govern_name, rule_name, params = nil)
    govern_name = govern_name.to_s
    rule_name = rule_name.to_s

    if respond_to?(:admin?) && admin?
      return true
    end

    unless rails_role[govern_name]
      return false
    end

    rule = rails_role[govern_name][rule_name] || rails_role[govern_name]['admin']

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

    if any_roles.is_a?(Array)
      return true if (any_roles.map(&:to_s) & rails_role.keys).present?
    end

    roles_hash.stringify_keys!
    roles_hash.slice(*rails_role.keys).each do |govern, rules|
      h_keys = rails_role[govern].select { |i| i }.keys
      rules = Array(rules).map(&:to_s)
      return true if (h_keys & rules).present?
    end

    false
  end

end
