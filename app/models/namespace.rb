class Namespace < ApplicationRecord
  include RailsRole::Namespace
end unless defined? Namespace
