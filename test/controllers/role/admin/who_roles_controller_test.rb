require 'test_helper'
class Role::Admin::WhoRolesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @role_admin_who_role = create role_admin_who_roles
  end

  test 'index ok' do
    get admin_who_roles_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_who_role_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('WhoRole.count') do
      post admin_who_roles_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_who_role_url(@role_admin_who_role)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_who_role_url(@role_admin_who_role)
    assert_response :success
  end

  test 'update ok' do
    patch admin_who_role_url(@role_admin_who_role), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('WhoRole.count', -1) do
      delete admin_who_role_url(@role_admin_who_role)
    end

    assert_response :success
  end

end
