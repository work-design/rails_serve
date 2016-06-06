module TheRole::BaseMethods

  def has_section? section_name
    section_name =  section_name.to_s
    return true if the_role[section_name]

    false
  end

  def has_role? section_name, rule_name
    section_name = section_name.to_s
    rule_name = rule_name.to_s

    return true if respond_to?(:admin?) && admin?

    return true if moderator? section_name

    return false unless the_role[section_name]
    return false unless the_role[section_name].key? rule_name

    the_role[section_name][rule_name]
  end

  def any_role? roles_hash = {}
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

  def write? section_name

  end

  def the_role_i18n
    the_role.each_with_object({}) do |(key, value), result|
      if I18n.exists?("#{key}.controller")
        k1 = I18n.t("#{key}.controller")
      else
        k1 = key
      end

      value.each_with_object({}) do |(k, v), result2|
        if I18n.exists?("#{key}.#{k}")
          t2 = I18n.t("#{key}.#{k}")
        else
          t2 = k
        end

        result2[t2] = v
        result[k1] = result2
      end

      result
    end
  end

end
