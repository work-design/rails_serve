class Section < ApplicationRecord

  has_many :rules
  validates :code, uniqueness: true

end

