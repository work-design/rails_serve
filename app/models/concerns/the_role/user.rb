module TheRole
  module User
    extend ActiveSupport::Concern
    include TheRole::BaseMethods

    included do
      belongs_to :who, optional: true
      delegate :the_role, to: :who, allow_nil: true
    end

    def owner?(obj, user_id = nil)
      return false unless obj
      return true if admin?

      section_name = obj.class.to_s.tableize
      return true if moderator?(section_name)

      return id == obj.id if obj.is_a?(self.class)

      return id == obj.user_id if obj.respond_to? :user_id
      return id == obj[:user_id] if obj[:user_id]
      return id == obj[:user][:id] if obj[:user]
      return id == user_id if user_id

      false
    end

    def admin?
      true if respond_to?(:email) && TheRole.default_admin_emails.include?(email)
    end

  end
end
