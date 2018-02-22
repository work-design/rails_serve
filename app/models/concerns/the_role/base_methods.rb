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

  def any_role?(roles_hash = {})
    roles_hash.each_pair do |govern, rules|
      return false unless[ Array, String, Symbol ].include?(rules.class)
      return has_role?(govern, rules) if [ String, Symbol ].include?(rules.class)
      rules.each{ |rule| return true if has_role?(govern, rule) }
    end

    false
  end


end
