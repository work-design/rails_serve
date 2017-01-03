class RoleRule < ApplicationRecord
  belongs_to :role
  belongs_to :rule
  belongs_to :section, optional: true

  after_commit :delete_cache, on: [:create, :destroy]
  before_save :sync_section_id

  def delete_cache
    if Rails.cache.delete("roles/#{role_id}")
      puts "-----> Cache key roles/#{role_id} deleted"
    end

    role.who_ids.each do |who_id|
      if Rails.cache.delete("who/#{who_id}")
        puts "-----> Cache key who/#{who_id} deleted"
      end
    end
  end

  def sync_section_id
    self.section_id = self.rule.section_id
  end

end

