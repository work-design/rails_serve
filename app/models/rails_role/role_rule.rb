module RailsRole::RoleRule
  extend ActiveSupport::Concern

  included do
    attribute :controller_identifier, :string
    attribute :action_identifier, :string
    attribute :params_name, :string
    attribute :params_identifier, :string

    belongs_to :role
    belongs_to :rule, foreign_key: :action_identifier, primary_key: :identifier
    belongs_to :govern, optional: true

    enum status: {
      available: 'available',
      unavailable: 'unavailable'
    }, _default: 'available'

    after_commit :delete_cache, on: [:create, :destroy]
    before_save :sync_govern_id
  end

  def delete_cache
    if Rails.cache.delete("rails_role/#{role_id}")
      puts "-----> Cache key rails_role/#{role_id} deleted"
    end
    if Rails.cache.delete("verbose_role/#{role_id}")
      puts "-----> Cache key verbose_role/#{role_id} deleted"
    end
    if Rails.cache.delete("taxon_codes/#{role_id}")
      puts "-----> Cache key taxon_codes/#{role_id} deleted"
    end
  end

  def sync_govern_id
    self.govern_id = self.rule.govern_id
    self.govern_taxon_id = self.govern.govern_taxon_id
  end

end

