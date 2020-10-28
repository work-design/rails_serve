class Business < ApplicationRecord
  include RailsRole::Business
end unless defined? Business
