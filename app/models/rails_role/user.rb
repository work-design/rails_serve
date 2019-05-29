module RailsRole::User
  extend ActiveSupport::Concern
  include RailsRole::Base

  included do
    attribute :cached_role_ids, :integer, array: true
    
    has_many :who_roles, as: :who, dependent: :destroy
    has_many :roles, through: :who_roles
    
    after_save :sync_to_role_ids, if: ->{ saved_change_to_cached_role_ids? }
  end

  def rails_role
    result = {}
    roles.map do |role|
      result.deep_merge!(role.rails_role.to_h) { |_, t, o| t || o }
    end

    result
  end

  def verbose_role
    result = {}
    roles.map do |role|
      result.deep_merge!(role.verbose_role.to_h) { |_, t, o| t || o }
    end

    result
  end
  
  def taxon_codes
    roles.map(&:taxon_codes).flatten
  end

  def admin?
    if respond_to?(:email) && RailsRole.default_admin_emails.include?(email)
      true
    end
  end
  
  def sync_to_role_ids
    self.role_ids = cached_role_ids
  end

end
