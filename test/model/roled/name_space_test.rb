require 'test_helper'

module Roled
  class NameSpaceTest < ActiveSupport::TestCase

    setup do
    end

    teardown do
      Rule.delete_all
    end

    test 'role_hash' do
      name_space = NameSpace.find_by identifier: 'panel'
      r = name_space.role_hash('roled')

      assert_includes r.keys, 'roled/panel/roles'
    end

  end
end
