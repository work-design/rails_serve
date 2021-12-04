module Roled
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoMemberRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
    end

    def default_role_hash
      Rails.cache.fetch('member_role_hash') do
        MemberRole.find_by(default: true)&.role_hash || {}
      end
    end

  end
end
