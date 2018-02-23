require 'acts_as_list'
class Rule < ApplicationRecord
  acts_as_list scope: :govern
  default_scope -> { order(position: :asc, id: :asc) }

  belongs_to :govern
  has_many :role_rules, dependent: :delete_all
  has_many :roles, through: :role_rules

  after_commit :delete_cache

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
      Rule.enum_i18n :code, self.code
    else
      name
    end
  end

  def desc
    "#{desc_name} [ #{code} #{params}]"
  end

  def delete_cache
    self.roles.each do |role|
      Rails.cache.delete("roles/#{role.id}")
    end
  end

end

