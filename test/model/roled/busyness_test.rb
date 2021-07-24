require 'test_helper'

module Roled
  class BusynessTest < ActiveSupport::TestCase

    test 'role_hash' do
      busyness = Busyness.find_by(identifier: 'roled')
      name_space = NameSpace.find_by(identifier: 'panel')
      r = busyness.role_hash

      assert_includes r.dig('roled'), name_space.identifier
    end

  end
end
