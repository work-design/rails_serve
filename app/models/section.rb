class Section < ApplicationRecord
  acts_as_list top_of_list: 0
  default_scope -> { order(position: :asc, id: :asc) }

  has_many :rules, -> { order(position: :asc) }
  #validates :code, uniqueness: true
  serialize :codes, Array



end

