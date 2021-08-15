require 'test_helper'

module Roled
  class MetaControllerTest < ActiveSupport::TestCase

    setup do
    end

    teardown do
      MetaAction.delete_all
    end

    test 'role_hash' do
      meta_controller = MetaController.find_by controller_path: 'roled/panel/roles'

      assert_instance_of Hash, meta_controller.role_hash
      assert_equal meta_controller.role_hash[meta_controller.controller_path].keys, meta_controller.meta_actions.pluck(:action_name)
    end

  end
end
