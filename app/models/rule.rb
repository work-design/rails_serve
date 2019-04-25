class Rule < ApplicationRecord
  include RailsRole::Rule
end unless defined? Rule
