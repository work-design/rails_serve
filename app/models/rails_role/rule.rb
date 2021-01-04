module RailsRole::Rule
  extend ActiveSupport::Concern

  included do
    attribute :namespace_identifier, :string
    attribute :business_identifier, :string
    attribute :controller_path, :string
    attribute :controller_name, :string
    attribute :action_name, :string
    attribute :path, :string
    attribute :verb, :string
    attribute :position, :integer

    belongs_to :govern, ->(o){ where(business_identifier: o.business_identifier, namespace_identifier: o.namespace_identifier) }, foreign_key: :controller_path, primary_key: :controller_path, optional: true

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

    acts_as_list scope: [:business_identifier, :namespace_identifier, :controller_path]
  end

  def identifier
    [business_identifier, namespace_identifier, controller_name, action_name].join('_')
  end

  def name
    t1 = I18n.t "#{[business_identifier, namespace_identifier, controller_name, action_name].join('.')}.title", default: nil
    return t1 if t1

    t2 = self.class.enum_i18n :action_name, self.action_name
    return t2 if t2

    identifier
  end

end

