require 'test_helper'
class Serve::Admin::ServersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @server = servers(:one)
  end

  test 'index ok' do
    get url_for(controller: 'serve/admin/servers')

    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'serve/admin/servers')

    assert_response :success
  end

  test 'create ok' do
    assert_difference('Server.count') do
      post(
        url_for(controller: 'serve/admin/servers', action: 'create'),
        params: { server: { member_id: @serve_admin_server.member_id, name: @serve_admin_server.name } },
        as: :turbo_stream
      )
    end

    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'serve/admin/servers', action: 'show', id: @server.id)

    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'serve/admin/servers', action: 'edit', id: @server.id)

    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'serve/admin/servers', action: 'update', id: @server.id),
      params: { server: { member_id: @serve_admin_server.member_id, name: @serve_admin_server.name } },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Server.count', -1) do
      delete url_for(controller: 'serve/admin/servers', action: 'destroy', id: @server.id), as: :turbo_stream
    end

    assert_response :success
  end

end
