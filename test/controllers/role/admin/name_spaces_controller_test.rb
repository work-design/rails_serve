require 'test_helper'
class Role::Admin::NameSpacesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @role_admin_name_space = create role_admin_name_spaces
  end

  test 'index ok' do
    get admin_name_spaces_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_name_space_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('NameSpace.count') do
      post admin_name_spaces_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_name_space_url(@role_admin_name_space)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_name_space_url(@role_admin_name_space)
    assert_response :success
  end

  test 'update ok' do
    patch admin_name_space_url(@role_admin_name_space), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('NameSpace.count', -1) do
      delete admin_name_space_url(@role_admin_name_space)
    end

    assert_response :success
  end

end
