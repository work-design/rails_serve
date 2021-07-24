require 'test_helper'

module Roled
  class GovernTest < ActiveSupport::TestCase

    setup do
    end

    teardown do
      Rule.delete_all
    end

    test 'role_hash' do
      govern = Govern.find_by controller_path: 'roled/panel/governs'

      assert_instance_of Hash, govern.role_hash
      assert_equal govern.role_hash.keys, govern.rules.pluck(:action_name)
    end

  end
end
