module Roled
  class MetaController < ApplicationRecord
    self.table_name = 'com_meta_controllers'
    include Model::MetaController
  end
end
