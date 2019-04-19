class Govern < ApplicationRecord
  acts_as_list

  belongs_to :govern_taxon, counter_cache: true, optional: true
  has_many :rules, -> { order(position: :asc) }, dependent: :destroy

  default_scope -> { order(position: :asc, id: :asc) }
  scope :without_taxon, -> { where(govern_taxon_id: nil) }

  validates :code, uniqueness: true

  def desc
    "#{name} [#{code}]"
  end

end
