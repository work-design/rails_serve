class Section < ApplicationRecord
  acts_as_list

  belongs_to :section_taxon, counter_cache: true
  has_many :rules, -> { order(position: :asc) }, dependent: :destroy

  default_scope -> { order(position: :asc, id: :asc) }
  scope :without_taxon, -> { where(section_taxon_id: nil) }

  validates :code, uniqueness: true

  def desc
    "#{name} (#{code})"
  end

end