module TheRole::BaseMethods

  def has_role?(section_name, rule_name, params = nil)
    section_name = section_name.to_s
    rule_name = rule_name.to_s

    if respond_to?(:admin?) && admin?
      return true
    end

    unless the_role[section_name] && the_role[section_name].key?(rule_name)
      return false
    end

    rule = the_role[section_name][rule_name] || the_role[section_name]['admin']

    if rule.is_a?(Array) && params.present?
      rule.include? params.to_s
    else
      rule
    end
  end

  def any_role?(roles_hash = {})
    roles_hash.each_pair do |section, rules|
      return false unless[ Array, String, Symbol ].include?(rules.class)
      return has_role?(section, rules) if [ String, Symbol ].include?(rules.class)
      rules.each{ |rule| return true if has_role?(section, rule) }
    end

    false
  end

end
