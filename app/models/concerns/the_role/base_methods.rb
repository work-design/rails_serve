module TheRole
  module BaseMethods

    def has_section? section_name
      section_name =  section_name.to_s
      return true if the_role[section_name]

      false
    end

    def has_role? section_name, rule_name
      section_name = section_name.to_s
      rule_name = rule_name.to_s

      return true if admin?
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
      true if moderators[section_name]
    end

    def moderators
      the_role['moderator'].to_h
    end

    def admin?
      true if the_role['system']
    end

  end
end
