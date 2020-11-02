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
    has_many :busynesses, -> { distinct }, through: :role_rules
    has_many :role_types, dependent: :delete_all

    scope :visible, -> { where(visible: true) }

    #before_save :sync_who_types
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
