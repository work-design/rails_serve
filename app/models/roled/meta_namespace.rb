module Roled
  class MetaNamespace < ApplicationRecord
    self.table_name = 'com_meta_namespaces'
    include Model::MetaNamespace
    include Com::Model::MetaNamespace
  end
end
