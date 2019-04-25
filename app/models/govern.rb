class Govern < ApplicationRecord
  include RailsRole::Govern
end unless defined? Govern
