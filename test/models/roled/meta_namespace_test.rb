require 'test_helper'

module Roled
  class MetaNamespaceTest < ActiveSupport::TestCase

    setup do
    end

    teardown do
      MetaNamespace.delete_all
    end

    test 'role_hash' do
      meta_namespace = MetaNamespace.find_by identifier: 'panel'

      assert_includes meta_namespace.role_hash('roled')[meta_namespace.identifier], 'roled/panel/roles'
    end

  end
end
