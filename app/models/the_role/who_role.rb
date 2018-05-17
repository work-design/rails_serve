class WhoRole < ApplicationRecord
  belongs_to :who, polymorphic: true
  belongs_to :role
  
end
