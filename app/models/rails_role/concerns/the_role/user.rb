module RailsRole::User
  extend ActiveSupport::Concern
  include RailsRole::BaseMethods

  included do
    has_many :who_roles, as: :who, dependent: :destroy
    has_many :roles, through: :who_roles
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

  def admin?
    if respond_to?(:email) && RailsRole.default_admin_emails.include?(email)
      true
    end
  end

end
