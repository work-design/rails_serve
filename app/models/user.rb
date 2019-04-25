class User < ApplicationRecord
  include RailsRole::User
end unless defined? User
