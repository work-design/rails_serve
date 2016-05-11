module TheRole
  module User
    extend ActiveSupport::Concern
    include TheRole::BaseMethods

    included do
    end

    def the_role
      result = {}
      roles.map do |r|
        result.deep_merge!(r.the_role.to_h) { |_, t, o| t || o }
      end

      result
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
      return true if respond_to?(:email) && email == TheRole.default_admin_email
      super
    end

  end
end
