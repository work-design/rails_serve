require 'test_helper'
class Roled::Panel::NameSpacesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @name_space = Roled::NameSpace.first
  end

  test 'index ok' do
    get url_for(controller: 'roled/panel/name_spaces')
    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'roled/panel/name_spaces', action: 'show', id: @name_space.id)
    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'roled/panel/name_spaces', action: 'edit', id: @name_space.id)
    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'roled/panel/name_spaces', action: 'show', id: @name_space.id),
      params: { name_space: { name: 'xx' } },
      as: :turbo_stream
    )

    @name_space.reload
    assert_equal 'xx', @name_space.name
    assert_response :success
  end

end
