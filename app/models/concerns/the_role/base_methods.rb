module TheRole::BaseMethods

  def has_role?(govern_name, rule_name, params = nil)
    govern_name = govern_name.to_s
    rule_name = rule_name.to_s

    if respond_to?(:admin?) && admin?
      return true
    end

    unless the_role[govern_name]
      return false
    end

    rule = the_role[govern_name][rule_name] || the_role[govern_name]['admin']

    if rule.blank?
      verbs = RailsCom::Routes.verbs govern_name, rule_name
      if verbs.include?('GET') && !rule_name.start_with?('new', 'edit')
        rule = the_role[govern_name]['read']
      end
    end

    if rule.is_a?(Array) && params.present?
      rule.include? params.to_s
    else
      rule
    end
  end

  def any_role?(*any_roles, **roles_hash)
    if any_roles.is_a?(Array)
      return true if (any_roles.map(&:to_s) & the_role.keys).present?
    end

    if respond_to?(:admin?) && admin?
      return true
    end

    roles_hash.stringify_keys!
    roles_hash.slice(*the_role.keys).each do |govern, rules|
      h_keys = the_role[govern].select { |i| i }.keys
      rules = Array(rules).map { |i| i.to_s }
      return true if (h_keys & rules).present?
    end

    false
  end

end
