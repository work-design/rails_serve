require 'test_helper'
class Role::Admin::BusynessesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @role_admin_busyness = create role_admin_busynesses
  end

  test 'index ok' do
    get admin_busynesses_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_busyness_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Busyness.count') do
      post admin_busynesses_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_busyness_url(@role_admin_busyness)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_busyness_url(@role_admin_busyness)
    assert_response :success
  end

  test 'update ok' do
    patch admin_busyness_url(@role_admin_busyness), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Busyness.count', -1) do
      delete admin_busyness_url(@role_admin_busyness)
    end

    assert_response :success
  end

end
