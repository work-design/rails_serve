module TheRole
  module Role
    include TheRole::BaseMethods
    extend ActiveSupport::Concern

    included do
      has_many :rules
      serialize :the_role, JSON
    end

    def create_section(section_name = nil)
      section_name = section_name.to_s

      return false if section_name.blank?
      return true if the_role[section_name]

      the_role[section_name] = {}
      save
    end

    def create_rule(section_name, rule_name)
      rule_name = rule_name.to_s
      section_name = section_name.to_s

      return false if section_name.to_s.blank? && rule_name.to_s.blank?

      the_role[section_name].merge! rule_name => true
      save
    end

    def rule_on(section_name, rule_name)
      rule_name = rule_name.to_s
      section_name = section_name.to_s

      return false unless the_role[section_name]

      the_role[section_name][rule_name] = true
      save
    end

    def rule_off(section_name, rule_name)
      rule_name = rule_name.to_s
      section_name = section_name.to_s

      return false unless the_role[section_name]

      the_role[section_name][rule_name] = false
      save
    end

    def delete_section(section_name = nil)
      section_name = section_name.to_s

      return false if section_name.blank?
      return false unless the_role[section_name]

      the_role.delete section_name
      save
    end

    def delete_rule(section_name, rule_name)
      rule_name    = rule_name.to_s
      section_name = section_name.to_s

      return false unless the_role[section_name]
      return false unless the_role[section_name].key? rule_name

      the_role[section_name].delete rule_name
      save
    end

  end
end
