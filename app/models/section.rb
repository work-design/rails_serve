class Section < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc, id: :asc) }

  has_many :rules, -> { order(position: :asc) }

  validates :code, uniqueness: true


end

