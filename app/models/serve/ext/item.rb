module Serve
  module Ext::Item
    extend ActiveSupport::Concern

    included do
      has_many :servings, class_name: 'Serve::Serving'
    end

  end
end
