require 'test_helper'

class NameSpaceTest < ActiveSupport::TestCase

  setup do
    NameSpace.sync
    Govern.sync
  end

  teardown do
    Govern.delete_all
    Rule.delete_all
  end

  test 'role_hash' do
    name_space = NameSpace.find_by identifier: 'panel'
    r = name_space.role_hash('role')

    assert_includes r.keys, 'roles'
  end

end
