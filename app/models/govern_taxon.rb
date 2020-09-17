class GovernTaxon < ApplicationRecord
  include RailsRole::GovernTaxon
  include RailsTaxon::Node
end unless defined? GovernTaxon
