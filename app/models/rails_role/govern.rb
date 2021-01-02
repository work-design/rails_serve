module RailsRole::Govern
  extend ActiveSupport::Concern

  included do
    attribute :identifier, :string, index: true
    attribute :namespace_identifier, :string, index: true
    attribute :business_identifier, :string, index: true
    attribute :controller_name, :string
    attribute :position, :integer

    belongs_to :name_space, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
    belongs_to :busyness, foreign_key: :business_identifier, primary_key: :identifier, optional: true

    has_many :rules, -> { order(position: :asc) }, foreign_key: :controller_identifier, primary_key: :identifier, dependent: :destroy, inverse_of: :govern
    has_many :role_rules, dependent: :destroy

    accepts_nested_attributes_for :rules, allow_destroy: true

    default_scope -> { order(position: :asc, id: :asc) }

    validates :identifier, uniqueness: true
    before_validation do
      self.identifier = [business_identifier, namespace_identifier, controller_name].compact.join('/')
    end

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

  def role_hash
    rules.each_with_object({}) { |i, h| h.merge! i.action_name => true }
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
      RailsCom::Routes.actions.each do |busyness, namespaces|
        namespaces.each do |namespace, governs|
          governs.each do |controller_name, all_rules|
            govern = Govern.find_or_initialize_by(business_identifier: busyness, namespace_identifier: namespace, controller_name: controller_name)

            present_rules = govern.rules.pluck(:action_name)
            (all_rules - present_rules).each do |action|
              govern.rules.build(action_name: action)
            end
            (present_rules - all_rules).each do |action|
              r = govern.rules.find_by(action_name: action)
              r.mark_for_destruction
            end

            govern.save if govern.rules.length > 0
          end

          present_controllers = Govern.where(business_identifier: busyness, namespace_identifier: namespace).pluck(:controller_name)
          Govern.where(business_identifier: busyness, namespace_identifier: namespace, controller_name: (present_controllers - governs.keys)).each do |govern|
            govern.destroy
          end
        end
      end
    end

  end

end
