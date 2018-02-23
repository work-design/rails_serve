module TheRole::User
  extend ActiveSupport::Concern
  include TheRole::BaseMethods

  included do
    has_many :who_roles, as: :who, dependent: :destroy
    has_many :roles, through: :who_roles
  end

  def the_role
    result = {}
    roles.map do |role|
      result.deep_merge!(role.the_role.to_h) { |_, t, o| t || o }
    end

    result
  end

  def admin?
    if respond_to?(:email) && TheRole.default_admin_emails.include?(email)
      true
    end
  end

end
