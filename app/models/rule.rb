class Rule < ApplicationRecord

  belongs_to :section

  has_many :role_rules, dependent: :destroy
  has_many :roles, through: :role_rules


end

