module Roled
  class MetaOperation < ApplicationRecord
    self.table_name = 'com_meta_operations'
    include Model::MetaOperation
    include Com::Model::MetaOperation
  end
end
