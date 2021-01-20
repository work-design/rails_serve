module Roled
  module Model::Govern
    extend ActiveSupport::Concern

    included do
      attribute :namespace_identifier, :string, index: true
      attribute :business_identifier, :string, index: true
      attribute :controller_path, :string
      attribute :controller_name, :string
      attribute :position, :integer

      belongs_to :name_space, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
      belongs_to :busyness, foreign_key: :business_identifier, primary_key: :identifier, optional: true

      has_many :rules, ->(o) { where(business_identifier: o.business_identifier, namespace_identifier: o.namespace_identifier).order(position: :asc) }, foreign_key: :controller_path, primary_key: :controller_path, dependent: :destroy, inverse_of: :govern
      has_many :role_rules, dependent: :destroy

      accepts_nested_attributes_for :rules, allow_destroy: true

      default_scope -> { order(position: :asc, id: :asc) }

      validates :controller_name, uniqueness: { scope: [:business_identifier, :namespace_identifier] }

      acts_as_list scope: [:namespace_identifier, :business_identifier]
    end

    def identifier
      [business_identifier, namespace_identifier, (controller_name.blank? ? '_' : controller_name)].join('_')
    end

    def business_name
      t = I18n.t "#{business_identifier}.title", default: nil
      return t if t

      business_identifier
    end

    def namespace_name
      t = I18n.t "#{business_identifier}.#{namespace_identifier}.title", default: nil
      return t if t

      namespace_identifier
    end

    def name
      t = I18n.t "#{controller_path.to_s.split('/').join('.')}.index.title", default: nil
      return t if t

      controller_path
    end

    def role_hash
      rules.each_with_object({}) { |i, h| h.merge! i.action_name => i.required_parts }
    end

    class_methods do

      def actions
        result = {}
        Busyness.all.includes(governs: :rules).each do |busyness|
          result.merge! busyness.identifier => busyness.governs.group_by(&:namespace_identifier).transform_values!(&->(governs){
            governs.each_with_object({}) { |govern, h| h.merge! govern.controller_name => govern.rules.pluck(:action_name) }
          })
        end
        result
      end

      def sync
        RailsCom::Routes.actions.each do |business, namespaces|
          namespaces.each do |namespace, controllers|
            controllers.each do |controller, actions|
              govern = Govern.find_or_initialize_by(business_identifier: business, namespace_identifier: namespace, controller_path: controller)
              govern.controller_name = controller.to_s.split('/')[-1]

              actions.each do |action_name, action|
                rule = govern.rules.find_or_initialize_by(action_name: action_name)
                rule.controller_name = govern.controller_name
                rule.path = action[:path]
                rule.verb = action[:verb]
                rule.required_parts = action[:required_parts]
              end

              present_rules = govern.rules.pluck(:action_name)
              govern.rules.where(action_name: (present_rules - actions.keys)).each do |rule|
                rule.mark_for_destruction
              end

              govern.save if govern.rules.length > 0
            end

            present_controllers = Govern.where(business_identifier: business, namespace_identifier: namespace).pluck(:controller_path)
            Govern.where(business_identifier: business, namespace_identifier: namespace, controller_path: (present_controllers - controllers.keys)).each do |govern|
              govern.destroy
            end
          end
        end
      end

    end

  end
end
