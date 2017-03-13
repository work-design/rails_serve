class SectionTaxon < ApplicationRecord
  acts_as_list

  has_many :sections, -> { order(position: :asc) }, dependent: :nullify
  default_scope -> { order(position: :asc, id: :asc) }

end