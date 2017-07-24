module TheRole::User
  extend ActiveSupport::Concern
  include TheRole::BaseMethods

  included do
    belongs_to :who, optional: true
  end

  def the_role
    if who
      who.the_role
    else
      {}
    end
  end

  def admin?
    if respond_to?(:email) && TheRole.default_admin_emails.include?(email)
      true
    end
  end

end
