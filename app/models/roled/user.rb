module Roled
  class User < ApplicationRecord
    include Ext::User

    self.table_name = Auth::User.table_name if defined? RailsAuth
  end
end
