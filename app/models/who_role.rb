class WhoRole < ApplicationRecord
  include RailsRole::WhoRole
end unless defined? WhoRole
