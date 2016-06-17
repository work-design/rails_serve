class WhoRole < ApplicationRecord

  belongs_to :who
  belongs_to :role

  after_commit :delete_cache, on: [:create, :destroy]

  def delete_cache
    Rails.cache.delete("who/#{who_id}")
  end
  
end
