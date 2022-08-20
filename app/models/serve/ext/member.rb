module Serve
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :servings, class_name: 'Serve::Serving'
    end

  end
end
