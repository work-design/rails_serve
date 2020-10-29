module RailsRole::Role
  extend ActiveSupport::Concern
  include RailsRoleExt::Base

  included do
    attribute :name, :string, null: false
    attribute :description, :string, limit: 1024
    attribute :visible, :boolean, default: false
    attribute :who_types, :string, array: true

    has_many :who_roles, dependent: :destroy
    has_many :role_rules, dependent: :destroy, inverse_of: :role
    has_many :rules, through: :role_rules, dependent: :destroy
    has_many :governs, ->{ distinct }, through: :role_rules
    has_many :govern_taxons, -> { distinct }, through: :role_rules
    has_many :role_types, dependent: :delete_all

    scope :visible, -> { where(visible: true) }

    #before_save :sync_who_types
  end

  def rails_role
    Rails.cache.fetch("rails_role/#{self.id}") do
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

  def verbose_role
    Rails.cache.fetch("verbose_role/#{self.id}") do
      result = {}
      governs.each do |govern|
        result[[govern.code, govern.name]] ||= {}
        rules.where(govern_id: govern.id).each do |rule|
          if rule.serialize_params.blank?
            result[[govern.code, govern.name]].merge! rule.code => [rule.desc_name]
          else
            result[[govern.code, govern.name]].merge! rule.code => [rule.desc_name, rule.serialize_params]
          end
        end
      end

      result
    end
  end

  def taxon_codes
    Rails.cache.fetch("taxon_codes/#{self.id}") do
      govern_taxons.map(&:code)
    end
  end

  def sync_who_types
    who_types.exists?(who)
  end

end
