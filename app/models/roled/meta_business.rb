module Roled
  class MetaBusiness < ApplicationRecord
    self.table_name = 'com_meta_businesses'
    include Model::MetaBusiness
    include Com::Model::MetaBusiness
  end
end
