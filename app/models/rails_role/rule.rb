module RailsRole::Rule
  extend ActiveSupport::Concern

  included do
    attribute :code, :string
    attribute :namespace_identifier, :string, default: 'application'
    attribute :business_identifier, :string
    attribute :controller_identifier, :string
    attribute :params, :string
    attribute :position, :integer

    belongs_to :govern, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
    has_many :role_rules, dependent: :delete_all
    has_many :roles, through: :role_rules

    default_scope -> { order(position: :asc, id: :asc) }
    scope :without_taxon, -> { where(govern_id: Govern.without_taxon.pluck(:id)) }

    after_commit :delete_cache

    acts_as_list scope: [:controller_identifier]
  end

  def serialize_params
    #todo regexp improve!
    return @serialize_params if @serialize_params
    if params =~ /^\[.*\]$/ || params =~ /\.{2,3}/
      @serialize_params = eval(params).to_a.map { |i| i.to_s }
    else
      nil
    end
  end

  def name
    t = I18n.t "#{code.split('/').join('.')}.title", default: nil
    return t if t

    code
  end

  def desc_name
    if name.blank?
      self.class.enum_i18n :code, self.code
    else
      name
    end
  end

  def desc
    "#{desc_name} [ #{code} #{params}]"
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

