class RoleRule < ApplicationRecord

  belongs_to :role
  belongs_to :rule

  after_commit :delete_cache, on: [:create, :destroy]

  def delete_cache
    Rails.cache.delete("roles/#{role_id}")
    Rails.cache.delete_matched('who/*')
  end

end

