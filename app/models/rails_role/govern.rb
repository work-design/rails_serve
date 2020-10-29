module RailsRole::Govern
  extend ActiveSupport::Concern

  included do
    attribute :identifier, :string, index: true
    attribute :namespace_identifier, :string, default: 'application', index: true
    attribute :business_identifier, :string, index: true
    attribute :position, :integer

    belongs_to :name_space, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
    belongs_to :busyness, foreign_key: :business_identifier, primary_key: :identifier, optional: true

    has_many :rules, -> { order(position: :asc) }, foreign_key: :controller_identifier, primary_key: :identifier, dependent: :destroy, inverse_of: :govern
    has_many :role_rules, dependent: :destroy

    accepts_nested_attributes_for :rules, allow_destroy: true

    default_scope -> { order(position: :asc, id: :asc) }

    validates :identifier, uniqueness: true

    acts_as_list scope: [:namespace_identifier, :business_identifier]
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
    t = I18n.t "#{identifier.to_s.split('/').join('.')}.index.title", default: nil
    return t if t

    identifier
  end

  class_methods do

    def sync
      present_controllers = Govern.unscoped.select(:identifier).distinct.pluck(:identifier)
      all_controllers = RailsCom::Routes.controllers.except!(*RailsRole.config.ignore_controllers).keys
      missing_controllers = all_controllers - present_controllers
      invalid_controllers = present_controllers - all_controllers

      RailsCom::Routes.controllers.extract!(*missing_controllers).each do |controller, routes|
        govern = Govern.find_or_initialize_by(identifier: controller)
        route = routes[0]
        govern.business_identifier = route[:business] if route[:business]
        govern.namespace_identifier = route[:namespace] if route[:namespace]

        present_rules = govern.rules.pluck(:identifier)
        all_rules = routes.map(&->(i){ i[:action] })
        (all_rules - present_rules).each do |action|
          govern.rules.build(action_name: action)
        end
        (present_rules - all_rules).each do |action|
          r = govern.rules.find_by(action_name: action)
          r.mark_for_destruction
        end

        govern.save if govern.rules.length > 0
      end

      Govern.where(identifier: invalid_controllers).each do |govern|
        govern.destroy
      end
    end

  end

end
