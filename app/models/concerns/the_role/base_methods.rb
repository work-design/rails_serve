module TheRole::BaseMethods

  def has_role?(section_name, rule_name, params = nil)
    section_name = section_name.to_s
    rule_name = rule_name.to_s

    return true if respond_to?(:admin?) && admin?

    return false unless the_role[section_name]
    return true if moderator? section_name

    return false unless the_role[section_name].key? rule_name
    rules = the_role[section_name][rule_name]

    if rules.is_a?(Array) && params.present?
      rules.include? params
    else
      rules
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

  def moderator? section_name
    the_role[section_name] && the_role[section_name]['admin']
  end

end
