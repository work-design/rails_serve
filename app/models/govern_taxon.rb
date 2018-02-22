class GovernTaxon < ApplicationRecord
  acts_as_list

  has_many :governs, -> { order(position: :asc) }, dependent: :nullify
  default_scope -> { order(position: :asc, id: :asc) }

end