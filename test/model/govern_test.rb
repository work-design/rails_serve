require 'test_helper'

class BusynessTest < ActiveSupport::TestCase

  setup do
    Govern.sync
  end

  test 'role_hash' do
    govern = Govern.find_by controller_path: 'role/panel/governs'

    assert_instance_of Hash, govern.role_hash
    assert_equal govern.role_hash.keys, govern.rules.pluck(:action_name)
  end

end
