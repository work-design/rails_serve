module Serve
  class Service < ApplicationRecord
    include Model::Service
    include Trade::Ext::Good
  end
end
