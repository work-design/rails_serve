module Roled
  module Model::WhoRole::WhoUserRole
    extend ActiveSupport::Concern

    included do
      belongs_to :who, class_name: 'Auth::User'
      belongs_to :role, class_name: 'UserRole'
    end

  end
end
