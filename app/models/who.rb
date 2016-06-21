class Who < ApplicationRecord
  include TheRole::User

  has_many :who_roles, dependent: :destroy
  has_many :roles, through: :who_roles

  def the_role
    Rails.cache.fetch("who/#{self.id}") do
      result = {}
      roles.map do |r|
        result.deep_merge!(r.the_role.to_h) { |_, t, o| t || o }
      end

      result
    end
  end
end