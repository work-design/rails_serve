module RailsRole::Govern
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :code, :string
    attribute :position, :integer

    belongs_to :namespace
    belongs_to :bussiness
    has_many :rules, -> { order(position: :asc) }, dependent: :destroy
    has_many :role_rules, dependent: :destroy
    accepts_nested_attributes_for :rules, allow_destroy: true

    default_scope -> { order(position: :asc, id: :asc) }

    validates :code, uniqueness: true

    after_create_commit :sync_govern_taxon

    acts_as_list
  end

  def desc
    "#{name} [#{code}]"
  end

  def name
    if super
      return super
    elsif code
      t = I18n.t "#{code.split('/').join('.')}.index.title", default: nil
      return t if t
    end

    code
  end

  def sync_govern_taxon
    path = code.split('/')
    path.pop
    if path.size > 0
      taxon = GovernTaxon.find_by code: path.join('/')
      self.govern_taxon_id = taxon&.id
      self.save
    end
  end

  class_methods do

    def sync_controllers
      missing_controllers, invalid_controllers = analyze_controllers
      RailsCom::Routes.controllers.extract!(*missing_controllers).each do |controller, routes|
        govern = ControllerGovern.find_or_initialize_by(code: controller)
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
      ControllerGovern.where(code: invalid_controllers).each do |controller|
        controller.destroy
      end
    end

    def analyze_controllers
      present_controllers = ControllerGovern.unscoped.select(:code).distinct.pluck(:code)
      all_controllers = RailsCom::Routes.controllers.except!(*RailsRole.config.ignore_controllers).keys

      missing_controllers = all_controllers - present_controllers
      invalid_controllers = present_controllers - all_controllers
      [missing_controllers, invalid_controllers]
    end

  end

end
