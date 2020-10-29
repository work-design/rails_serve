module RailsRole::Rule
  extend ActiveSupport::Concern

  included do
    attribute :identifier, :string
    attribute :namespace_identifier, :string, default: 'application'
    attribute :business_identifier, :string
    attribute :controller_identifier, :string
    attribute :action_identifier, :string
    attribute :position, :integer

    belongs_to :govern, foreign_key: :controller_identifier, primary_key: :identifier, optional: true

    enum operation: {
      list: 'list',
      read: 'read',
      add: 'add',
      edit: 'edit',
      remove: 'remove'
    }, _default: 'read'

    has_many :role_rules, dependent: :delete_all
    has_many :roles, through: :role_rules

    default_scope -> { order(position: :asc, id: :asc) }
    scope :without_taxon, -> { where(govern_id: Govern.without_taxon.pluck(:id)) }

    after_commit :delete_cache

    acts_as_list scope: [:controller_identifier]
  end

  def name
    t = I18n.t "#{identifier.split('/').join('.')}.title", default: nil
    return t if t

    identifier
  end

  def desc_name
    if name.blank?
      self.class.enum_i18n :code, self.code
    else
      name
    end
  end

  def delete_cache
    self.roles.each do |role|
      if Rails.cache.delete("rails_role/#{role.id}")
        puts "-----> Cache key rails_role/#{role.id} deleted"
      end
      if Rails.cache.delete("verbose_role/#{role.id}")
        puts "-----> Cache key verbose_role/#{role.id} deleted"
      end
    end
  end

end

