require 'test_helper'

class TheAuth::JoinControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create :user
  end

  test "should get index" do
    get testsses_url
    assert_response :success
  end


  test "should create testss" do
    assert_difference('Testss.count') do
      post testsses_url, params: { testss: {  } }
    end

    assert_redirected_to testss_url(Testss.last)
  end


  test "should destroy testss" do
    assert_difference('Testss.count', -1) do
      delete testss_url(@testss)
    end

    assert_redirected_to testsses_url
  end
end
