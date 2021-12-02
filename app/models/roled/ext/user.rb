module Roled
  module Ext::User
    extend ActiveSupport::Concern

    included do
      include Ext::Base

      has_many :who_roles, class_name: 'Roled::WhoUserRole', dependent: :destroy_async
      has_many :roles, class_name: 'Roled::UserRole', through: :who_roles
    end

    def default_role_hash
      Rails.cache.fetch('default_role_hash') do
        UserRole.find_by(default: true)&.role_hash || {}
      end
    end

  end
end
