require 'test_helper'

class TheAuthUserTest < ActiveSupport::TestCase



  test 'clear_reset_token!' do
    user = create :user
    user.clear_reset_token!

    assert_equal '', user.reset_token
  end

end
