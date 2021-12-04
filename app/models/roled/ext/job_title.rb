module Roled
  module Ext::JobTitle
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoJobTitleRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
    end

    def default_role_hash
      Rails.cache.fetch('job_title_role_hash') do
        JobTitleRole.find_by(default: true)&.role_hash || {}
      end
    end

  end
end
