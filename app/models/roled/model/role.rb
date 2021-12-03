module Roled
  module Model::Role
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :description, :string
      attribute :visible, :boolean, default: false
      attribute :role_hash, :json, default: {}
      attribute :default, :boolean
      attribute :type, :string

      has_many :who_roles, dependent: :destroy_async
      has_many :role_rules, dependent: :destroy_async, autosave: true, inverse_of: :role
      has_many :rules, through: :role_rules, dependent: :destroy_async
      has_many :controllers, ->{ distinct }, through: :role_rules
      has_many :busynesses, -> { distinct }, through: :role_rules
      has_many :role_types, dependent: :delete_all

      scope :visible, -> { where(visible: true) }

      validates :name, presence: true

      #before_save :sync_who_types
      after_update :set_default, if: -> { default? && (saved_change_to_default? || saved_change_to_type?) }
      after_commit :delete_cache, if: -> { default? && saved_change_to_role_hash? }
      after_save :sync, if: -> { saved_change_to_role_hash? }
    end

    def has_role?(business: nil, namespace: nil, controller: nil, action: nil, **params)
      controller = controller.to_s.delete_prefix('/').presence
      business ||= RailsExtend::Routes.controller_paths[controller][:business]
      namespace ||= RailsExtend::Routes.controller_paths[controller][:namespace] if controller.present?
      opts = [business, namespace, controller, action].take_while(&->(i){ !i.nil? })
      return false if opts.blank?

      r = role_hash.dig(*opts)
      logger.debug "\e[35m  Role: #{opts} is #{r} \e[0m"
      r
    end

    def set_default
      self.class.where.not(id: self.id).where(type: self.type).update_all(default: false)
      delete_cache
    end

    def sync_who_types
      who_types.exists?(who)
    end

    def business_on(meta_business)
      role_hash.deep_merge! meta_business.role_path
    end

    def business_off(meta_business)
      role_hash.delete meta_business.identifier.to_s

      role_hash
    end

    def business_role(meta_business)
      r = has_role?(business: meta_business.identifier)

      if r == meta_business.role_hash
        1
      elsif r.blank?
        0
      end
    end

    def namespace_on(meta_namespace, business_identifier)
      role_hash.deep_merge! meta_namespace.role_path(business_identifier)
    end

    def namespace_off(meta_namespace, business_identifier)
      namespaces_hash = role_hash.fetch(business_identifier)
      return if namespaces_hash.blank?
      namespaces_hash.delete(meta_namespace.identifier)

      if namespaces_hash.blank?
        role_hash.delete(business_identifier)
      end

      role_hash
    end

    def namespace_role(meta_namespace, business_identifier = '')
      r = has_role?(
        business: business_identifier,
        namespace: meta_namespace.identifier
      )

      if r == meta_namespace.role_hash(business_identifier)
        1
      elsif r.blank?
        0
      end
    end

    def controller_on(meta_controller)
      role_hash.deep_merge! meta_controller.role_path
    end

    def controller_off(meta_controller)
      namespaces_hash = role_hash.fetch(meta_controller.business_identifier)
      return if namespaces_hash.blank?
      controllers_hash = namespaces_hash.fetch(meta_controller.namespace_identifier)
      return if controllers_hash.blank?
      controllers_hash.delete(meta_controller.controller_path)

      if controllers_hash.blank?
        namespaces_hash.delete(meta_controller.namespace_identifier)
      end
      if namespaces_hash.blank?
        role_hash.delete(meta_controller.business_identifier)
      end

      role_hash
    end

    def controller_role(meta_controller)
      r = has_role?(controller: meta_controller.controller_path)
      if r == meta_controller.role_hash
        1
      elsif r.blank?
        0
      end
    end

    def action_on(meta_action)
      role_hash.deep_merge!(meta_action.role_path)
    end

    def action_off(meta_action)
      namespaces_hash = role_hash.fetch(meta_action.business_identifier)
      return if namespaces_hash.blank?
      controllers_hash = namespaces_hash.fetch(meta_action.namespace_identifier)
      return if controllers_hash.blank?
      actions_hash = controllers_hash.fetch(meta_action.controller_path)
      return if actions_hash.blank?

      actions_hash.delete(meta_action.action_name)
      if actions_hash.blank?
        controllers_hash.delete(meta_action.controller_path)
      end
      if controllers_hash.blank?
        namespaces_hash.delete(meta_action.namespace_identifier)
      end
      if namespaces_hash.blank?
        role_hash.delete(meta_action.business_identifier)
      end

      role_hash
    end

    def role_rule_hash
      role_rules.group_by(&:business_identifier).transform_values! do |businesses|
        businesses.group_by(&:namespace_identifier).transform_values! do |namespaces|
          namespaces.group_by(&:controller_path).transform_values! do |controllers|
            controllers.each_with_object({}) { |i, h| h.merge! i.action_name => i.meta_action_id }
          end
        end
      end
    end

    def sync
      moved, add = role_rule_hash.diff_changes role_hash
      remove_role_rule(moved)
      add_role_rule(add)
    end

    def add_role_rule(add)
      add_attrs = []

      add.each do |business, namespaces|
        namespaces.each do |namespace, controllers|
          controllers.each do |controller, actions|
            actions.each do |action|
              add_attrs << {
                role_id: id,
                business_identifier: business,
                namespace_identifier: namespace,
                controller_path: controller,
                action_name: action[0],
                meta_action_id: action[1],
                created_at: Time.current,
                updated_at: Time.current
              }
            end
          end
        end
      end

      if add_attrs.present?
        RoleRule.insert_all(add_attrs)
      end
    end

    def remove_role_rule(moved)
      moved_ids = []

      moved.each do |business, namespaces|
        namespaces.each do |namespace, controllers|
          controllers.each do |controller, actions|
            moved_ids += role_rules.select(&->(i) { i.business_identifier == business && i.namespace_identifier == namespace && i.controller_path == controller && actions.keys.include?(i.action_name)  }).map(&:id)
          end
        end
      end

      RoleRule.where(id: moved_ids).delete_all if moved_ids.present?
    end

    def delete_cache
      puts 'should implement in subclass'
    end

  end
end
