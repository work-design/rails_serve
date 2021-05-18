module Roled
  class User < ApplicationRecord
    include Model::User

    self.table_name = 'users'
  end
end
