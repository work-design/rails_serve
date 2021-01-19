module Roled
  module Model::User
    extend ActiveSupport::Concern

    included do
      attribute :cached_role_ids, :integer, array: true

      has_many :who_roles, as: :who, dependent: :destroy
      has_many :roles, through: :who_roles

      after_save :sync_to_role_ids, if: ->{ saved_change_to_cached_role_ids? }
    end

    def admin?
      if respond_to?(:account_identities) && (RailsRole.config.default_admin_accounts & account_identities).length > 0
        true
      elsif respond_to?(:identity) && RailsRole.config.default_admin_accounts.include?(identity)
        true
      elsif method(:admin?).super_method
        super
      end
    end

    def role_hash
      result = default_role_hash
      roles.each do |role|
        result.deep_merge! role.role_hash
      end

      result
    end

    def default_role_hash
      Rails.cache.fetch('default_role_hash') do
        Role.find_by(default: true)&.role_hash || {}
      end
    end

    def has_role?(params: {}, **options)
      if respond_to?(:admin?) && admin?
        return true
      end

      options[:business] = options[:business].to_s if options.key?(:business)
      options[:namespace] = options[:namespace].to_s if options.key?(:namespace)

      opts = [options[:business], options[:namespace], options[:controller], options[:action]].take_while(&->(i){ !i.nil? })
      logger.debug "  \e[35m----- User: #{opts} -----\e[0m"
      return false if opts.blank?
      role_hash.dig(*opts).present?
    end

    def any_role?(*any_roles, **roles_hash)
      if respond_to?(:admin?) && admin?
        return true
      end

      if (any_roles.map(&:to_s) & rails_role.keys).present?
        return true
      end

      roles_hash.stringify_keys!
      roles_hash.slice(*rails_role.keys).each do |govern, rules|
        h_keys = rails_role[govern].select { |i| i }.keys
        rules = Array(rules).map(&:to_s)
        return true if (h_keys & rules).present?
      end

      false
    end

    def sync_to_role_ids
      self.role_ids = cached_role_ids
    end

  end
end
