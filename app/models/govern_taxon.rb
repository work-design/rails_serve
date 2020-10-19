class GovernTaxon < ApplicationRecord
  include RailsRole::GovernTaxon
  include RailsCom::Taxon
end unless defined? GovernTaxon
