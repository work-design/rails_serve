class Role < ApplicationRecord
  include TheRole::BaseMethods

  has_many :who_roles, dependent: :destroy
  has_many :role_rules, dependent: :destroy, inverse_of: :role
  has_many :rules, through: :role_rules, dependent: :destroy
  has_many :governs, ->{ distinct }, through: :role_rules, source: 'govern', dependent: :nullify

  def the_role
    Rails.cache.fetch("roles/#{self.id}") do
      result = {}
      governs.each do |govern|
        result[govern.code] ||= {}
        rules.where(govern_id: govern.id).each do |rule|
          if rule.serialize_params.blank?
            result[govern.code].merge! rule.code => true
          else
            result[govern.code].merge! rule.code => rule.serialize_params
          end
        end
      end

      result
    end
  end

end