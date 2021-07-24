require 'test_helper'
class Roled::Panel::BusynessesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @busyness = Roled::Busyness.first
  end

  test 'index ok' do
    get url_for(controller: 'roled/panel/busynesses')
    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'roled/panel/busynesses', action: 'show', id: @busyness.id)
    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'roled/panel/busynesses', action: 'edit', id: @busyness.id)
    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'roled/panel/busynesses', action: 'update', id: @busyness.id),
      params: { busyness: { name: 'xx' } },
      as: :turbo_stream
    )
    assert_response :success
  end

end
