module TheRole
  module Api
    module ActiveRecord
      def has_the_role
        include TheRole::Api::User
      end

      def acts_as_the_role
        include TheRole::Api::Role
      end
    end
  end
end
