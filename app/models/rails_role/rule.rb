module RailsRole::Rule
  extend ActiveSupport::Concern
  included do
    attribute :name, :string
    attribute :code, :string
    attribute :params, :string
    attribute :position, :integer, default: 1
    
    belongs_to :govern, optional: true
    has_many :role_rules, dependent: :delete_all
    has_many :roles, through: :role_rules

    default_scope -> { order(position: :asc, id: :asc) }
    scope :without_taxon, -> { where(govern_id: Govern.without_taxon.pluck(:id)) }

    after_commit :delete_cache

    acts_as_list scope: :govern
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

