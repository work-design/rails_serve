require 'test_helper'
class Role::Admin::BusynessesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @busyness = create :busyness
  end

  test 'index ok' do
    get '/panel/businesses'
    assert_response :success
  end

  test 'new ok' do
    get new_admin_busyness_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Busyness.count') do
      post admin_busynesses_url, params: { }
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_busyness_url(@busyness)
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_busyness_url(@busyness)
    assert_response :success
  end

  test 'update ok' do
    patch admin_busyness_url(@busyness), params: { }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Busyness.count', -1) do
      delete admin_busyness_url(@busyness)
    end

    assert_response :success
  end

end
