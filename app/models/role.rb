class Role < ApplicationRecord
  include TheRole::Role

  has_many :who_roles, dependent: :destroy
  has_many :whos, through: :who_roles

end