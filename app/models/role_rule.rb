class RoleRule < ApplicationRecord
  include RailsRole::RoleRule
end unless defined? RoleRule
