module Roled
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoOrganRole', foreign_key: :who_id, inverse_of: :who, dependent: :destroy_async
      accepts_nested_attributes_for :who_roles
      include Ext::Base
    end

    def default_role_hash
      Rails.cache.fetch('organ_role_hash') do
        OrganRole.find_by(default: true)&.role_hash || {}
      end
    end

  end
end
