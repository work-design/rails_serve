module Serve
  class Service < ApplicationRecord
    include Trade::Ext::Good
    include Model::Service
  end
end
