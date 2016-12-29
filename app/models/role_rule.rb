class RoleRule < ApplicationRecord
  belongs_to :role
  belongs_to :rule
  belongs_to :section

  after_commit :delete_cache, on: [:create, :destroy]

  def delete_cache
    Rails.cache.delete("roles/#{role_id}")
    Who.pluck(:id).each do |who_id|
      Rails.cache.delete("who/#{who_id}")
    end
  end

end

