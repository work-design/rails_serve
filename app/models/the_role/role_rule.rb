class RoleRule < ApplicationRecord
  belongs_to :role
  belongs_to :rule
  belongs_to :govern, optional: true

  after_commit :delete_cache, on: [:create, :destroy]
  before_save :sync_govern_id

  def delete_cache
    if Rails.cache.delete("the_role/#{role_id}")
      puts "-----> Cache key the_role/#{role_id} deleted"
    end
    if Rails.cache.delete("verbose_role/#{role_id}")
      puts "-----> Cache key verbose_role/#{role_id} deleted"
    end
  end

  def sync_govern_id
    self.govern_id = self.rule.govern_id
  end

end

