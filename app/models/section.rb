class Section < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc, id: :asc) }

  has_many :rules, -> { order(position: :asc) }, dependent: :destroy

  validates :code, uniqueness: true


  def desc
    "#{name} (#{code})"
  end

end

