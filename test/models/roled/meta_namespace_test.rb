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
      r = meta_namespace.role_hash('roled')

      assert_includes r.keys, 'roled/panel/roles'
    end

  end
end
