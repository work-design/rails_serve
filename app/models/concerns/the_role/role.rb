module TheRole
  module Role
    include TheRole::BaseMethods
    extend ActiveSupport::Concern

    included do
      attr_accessor :based_on_role

      serialize :the_role, JSON

      has_many  :users, dependent: TheRole.config.destroy_strategy
      validates :name,  presence: true, uniqueness: true
      validates :title, presence: true, uniqueness: true
      validates :description, presence: true

      private

      after_create do
        if based_on_role.present?
          if base_role = self.class.where(id: based_on_role).first
            update_role base_role.to_hash
          end
        end
      end

    end

    # C
    def create_section section_name = nil
      section_name = section_name.to_s

      return false if section_name.blank?
      return true if the_role[section_name]

      the_role[section_name] = {}
      save
    end

    def create_rule section_name, rule_name
      rule_name = rule_name.to_s
      section_name = section_name.to_s

      return false if rule_name.to_s.blank?
      return false unless create_section(section_name)

      return true if the_role[section_name][rule_name]

      the_role[section_name][rule_name] = false
      save
    end


    # Update
    def rule_on section_name, rule_name
      rule_name = rule_name.to_s
      section_name = section_name.to_s

      return false unless the_role[section_name]

      the_role[section_name][rule_name] = true
      save
    end

    def rule_off section_name, rule_name
      rule_name = rule_name.to_s
      section_name = section_name.to_s

      return false unless the_role[section_name]

      role[section_name][rule_name] = false
      save
    end

    # Delete
    def delete_section section_name = nil
      section_name = section_name.to_s

      return false if section_name.blank?
      return false unless the_role[section_name]

      the_role.delete section_name
      save
    end

    def delete_rule section_name, rule_name
      rule_name    = rule_name.to_s
      section_name = section_name.to_s

      return false unless the_role[section_name]
      return false unless the_role[section_name].key? rule_name

      the_role[section_name].delete rule_name
      save
    end

  end
end
