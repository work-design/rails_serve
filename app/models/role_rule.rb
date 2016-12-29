class RoleRule < ApplicationRecord
  belongs_to :role
  belongs_to :rule
  belongs_to :section, optional: true

  after_commit :delete_cache, on: [:create, :destroy]
  after_save :sync_section_id

  def delete_cache
    Rails.cache.delete("roles/#{role_id}")
    Who.pluck(:id).each do |who_id|
      Rails.cache.delete("who/#{who_id}")
    end
  end

  def sync_section_id
    self.section_id = self.rule.section_id
  end

end

