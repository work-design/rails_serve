module RailsRole::Govern
  extend ActiveSupport::Concern

  included do
    attribute :code, :string
    attribute :namespace_identifier, :string, default: 'application'
    attribute :business_identifier, :string
    attribute :position, :integer

    belongs_to :name_space, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
    belongs_to :busyness, foreign_key: :business_identifier, primary_key: :identifier, optional: true
    has_many :rules, -> { order(position: :asc) }, dependent: :destroy
    has_many :role_rules, dependent: :destroy
    accepts_nested_attributes_for :rules, allow_destroy: true

    default_scope -> { order(position: :asc, id: :asc) }

    validates :code, uniqueness: true

    after_create_commit :sync_controller

    acts_as_list scope: [:namespace_identifier, :business_identifier]
  end

  def desc
    "#{name} [#{code}]"
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
    t = I18n.t "#{code.to_s.split('/').join('.')}.index.title", default: nil
    return t if t

    code
  end

  class_methods do

    def sync
      missing_controllers, invalid_controllers = analyze_controllers
      RailsCom::Routes.controllers.extract!(*missing_controllers).each do |controller, routes|
        govern = Govern.find_or_initialize_by(code: controller)
        route = routes[0]
        govern.business_identifier = route[:business]
        govern.namespace_identifier = route[:namespace]

        present_rules = govern.rules.pluck(:code)

        all_rules = routes.map(&->(i){ i[:action] })
        all_rules = ['admin', 'read'] + all_rules if all_rules.present?

        (all_rules - present_rules).each do |action|
          govern.rules.build(code: action)
        end

        (present_rules - all_rules).each do |action|
          r = govern.rules.find_by(code: action)
          r.mark_for_destruction
        end

        govern.save if govern.rules.length > 0
      end

      Govern.where(code: invalid_controllers).each do |govern|
        govern.destroy
      end
    end

    def analyze_controllers
      present_controllers = Govern.unscoped.select(:code).distinct.pluck(:code)
      all_controllers = RailsCom::Routes.controllers.except!(*RailsRole.config.ignore_controllers).keys

      missing_controllers = all_controllers - present_controllers
      invalid_controllers = present_controllers - all_controllers
      [missing_controllers, invalid_controllers]
    end

  end

end
