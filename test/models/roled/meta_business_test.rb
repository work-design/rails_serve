require 'test_helper'

module Roled
  class MetaBusinessTest < ActiveSupport::TestCase

    test 'role_hash' do
      meta_business = MetaBusiness.find_by(identifier: 'roled')
      meta_namespace = MetaNamespace.find_by(identifier: 'panel')
      r = meta_business.role_hash

      assert_includes r.dig('roled'), meta_namespace.identifier
    end

  end
end
