module Roled
  class MetaAction < ApplicationRecord
    self.table_name = 'com_meta_actions'
    include Model::MetaAction
    include Com::Model::MetaAction
  end
end
