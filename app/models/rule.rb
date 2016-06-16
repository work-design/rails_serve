class Rule < ApplicationRecord
  acts_as_list scope: :section, top_of_list: 0
  default_scope -> { order(position: :asc, id: :asc) }

  belongs_to :section
  has_many :role_rules, dependent: :destroy
  has_many :roles, through: :role_rules
  validates :code, uniqueness: { scope: :section_id }

end

