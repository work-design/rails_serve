class Role < ApplicationRecord
  include RailsRole::Role
end unless defined? Role
