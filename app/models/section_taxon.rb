class SectionTaxon < ApplicationRecord
  acts_as_list

  has_many :sections, -> { order(position: :asc) }, counter_cache: true, dependent: :nullify
  default_scope -> { order(position: :asc, id: :asc) }

end