class Busyness < ApplicationRecord
  include RailsRole::Busyness
end unless defined? Busyness
