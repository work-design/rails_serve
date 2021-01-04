require 'test_helper'

class BusynessTest < ActiveSupport::TestCase

  setup do
    @busyness = create :busyness
  end

  test 'role_hash' do
    r = @busyness.role_hash

    assert_equal @busyness.identifier, r.keys.first
  end


end
