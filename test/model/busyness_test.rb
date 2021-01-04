require 'test_helper'

class BusynessTest < ActiveSupport::TestCase

  setup do
    Busyness.sync
    NameSpace.sync
    Govern.sync
  end

  test 'role_hash' do
    busyness = Busyness.find_by(identifier: 'role')
    name_space = NameSpace.find_by(identifier: 'panel')
    r = busyness.role_hash

    assert_includes r.dig('role'), name_space.identifier
  end


end
