module RailsRole::Rule
  extend ActiveSupport::Concern

  included do
    attribute :identifier, :string, index: true
    attribute :namespace_identifier, :string
    attribute :business_identifier, :string
    attribute :controller_identifier, :string, index: true
    attribute :controller_name, :string
    attribute :action_name, :string
    attribute :position, :integer

    belongs_to :govern, foreign_key: :controller_identifier, primary_key: :identifier, optional: true

    enum operation: {
      list: 'list',
      read: 'read',
      add: 'add',
      edit: 'edit',
      remove: 'remove'
    }, _default: 'read'

    has_many :role_rules, ->(o) { where(controller_identifier: o.controller_identifier) }, foreign_key: :action_name, primary_key: :identifier, dependent: :delete_all
    has_many :roles, through: :role_rules

    default_scope -> { order(position: :asc, id: :asc) }

    before_validation :sync_from_govern

    acts_as_list scope: [:controller_identifier]
  end

  def name
    t1 = I18n.t "#{identifier.split('/').join('.')}.title", default: nil
    return t1 if t1

    t2 = self.class.enum_i18n :action_name, self.action_name
    return t2 if t2

    identifier
  end

  def sync_from_govern
    self.business_identifier = govern.business_identifier
    self.namespace_identifier = govern.namespace_identifier
    self.controller_identifier = govern.identifier
    self.identifier = "#{controller_identifier}/#{action_name}"
  end

end

