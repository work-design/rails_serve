class GovernTaxon < ApplicationRecord
  include RailsRole::GovernTaxon
  prepend RailsTaxon::Node
end unless defined? GovernTaxon
