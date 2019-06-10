class RoleType < ApplicationRecord
  include RailsRole::RoleType
end unless defined? RoleType
