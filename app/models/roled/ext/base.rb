module Roled
  module Ext::Base
    extend ActiveSupport::Concern

    included do
      has_many :roles, class_name: 'Roled::Role', through: :who_roles
      has_many :role_rules, class_name: 'Roled::RoleRule', through: :who_roles
      has_many :meta_actions, class_name: 'Roled::MetaAction', through: :role_rules
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

    def has_role?(**options)
      if respond_to?(:admin?) && admin?
        return true
      end

      options[:business] = options[:business].to_s if options.key?(:business)
      options[:namespace] = options[:namespace].to_s if options.key?(:namespace)

      opts = [options[:business], options[:namespace], options[:controller].to_s.delete_prefix('/').presence, options[:action]].take_while(&->(i){ !i.nil? })
      return false if opts.blank?
      r = role_hash.dig(*opts)
      logger.debug "\e[35m  User: #{opts}  \e[0m"
      r
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

    def landmark_rules
      _rule_ids = role_hash.leaves
      Com::MetaAction.where(id: _rule_ids, landmark: true)
    end

  end
end
