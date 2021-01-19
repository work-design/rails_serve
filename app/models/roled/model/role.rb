module Roled
  module Model::Role
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :description, :string
      attribute :visible, :boolean, default: false
      attribute :who_types, :string, array: true
      attribute :role_hash, :json, default: {}
      attribute :default, :boolean

      has_many :who_roles, dependent: :destroy
      has_many :role_rules, dependent: :destroy, inverse_of: :role
      has_many :rules, through: :role_rules, dependent: :destroy
      has_many :governs, ->{ distinct }, through: :role_rules
      has_many :busynesses, -> { distinct }, through: :role_rules
      has_many :role_types, dependent: :delete_all

      scope :visible, -> { where(visible: true) }

      validates :name, presence: true

      #before_save :sync_who_types
      after_update :set_default, if: -> { default? && saved_change_to_default? }
      after_commit :delete_cache, if: -> { default? && saved_change_to_role_hash? }
    end

    def has_role?(params: {}, **options)
      options[:business] = options[:business].to_s if options.key?(:business)
      options[:namespace] = options[:namespace].to_s if options.key?(:namespace)

      opts = [options[:business], options[:namespace], options[:controller], options[:action]].take_while(&->(i){ !i.nil? })
      logger.debug "  \e[35m----- Role:#{opts} -----\e[35m"
      return false if opts.blank?
      role_hash.dig(*opts).present?
    end

    def set_default
      self.class.where.not(id: self.id).update_all(default: false)
      delete_cache
    end

    def delete_cache
      if Rails.cache.delete('default_role_hash')
        logger.debug "----------> delete cache default role hash"
      end
    end

    def sync_who_types
      who_types.exists?(who)
    end

  end
end
