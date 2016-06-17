module TheRole
  module Role
    include TheRole::BaseMethods
    extend ActiveSupport::Concern

    included do
      has_many :role_rules, dependent: :destroy
      has_many :rules, through: :role_rules
      has_many :sections, through: :rules
    end

    def the_role
      Rails.cache.fetch("roles/#{self.id}") do
        result = {}
        sections.each do |section|
          result[section.code] ||= {}
          rules.where(section_id: section.id).each do |rule|
            result[section.code].merge! rule.code => true
          end
        end
        result
      end
    end

  end
end
