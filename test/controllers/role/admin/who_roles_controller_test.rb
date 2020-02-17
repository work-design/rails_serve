require 'test_helper'
class Role::Admin::WhoRolesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @who_role = create :who_role
  end

  test 'index ok' do
    get admin_role_who_roles_url(@who_role.role)
    assert_response :success
  end

  test 'new ok' do
    get new_admin_role_who_role_url(@who_role.role), xhr: true
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('WhoRole.count', -1) do
      delete admin_role_who_role_url(@who_role.role, @who_role), xhr: true
    end

    assert_response :success
  end

end
