module RailsRole::Govern
  extend ActiveSupport::Concern
  included do
    acts_as_list

    belongs_to :govern_taxon, counter_cache: true, optional: true
    has_many :rules, -> { order(position: :asc) }, dependent: :destroy
    has_many :role_rules, dependent: :destroy
    accepts_nested_attributes_for :rules, allow_destroy: true
    
    default_scope -> { order(position: :asc, id: :asc) }
    scope :without_taxon, -> { where(govern_taxon_id: nil) }

    validates :code, uniqueness: true
  end

  def desc
    "#{name} [#{code}]"
  end

end
