require 'test_helper'
class Serve::Admin::ServicesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @service = services(:one)
  end

  test 'index ok' do
    get url_for(controller: 'serve/admin/services')

    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'serve/admin/services')

    assert_response :success
  end

  test 'create ok' do
    assert_difference('Service.count') do
      post(
        url_for(controller: 'serve/admin/services', action: 'create'),
        params: { service: { name: @serve_admin_service.name, price: @serve_admin_service.price, unit: @serve_admin_service.unit, vip_price: @serve_admin_service.vip_price } },
        as: :turbo_stream
      )
    end

    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'serve/admin/services', action: 'show', id: @service.id)

    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'serve/admin/services', action: 'edit', id: @service.id)

    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'serve/admin/services', action: 'update', id: @service.id),
      params: { service: { name: @serve_admin_service.name, price: @serve_admin_service.price, unit: @serve_admin_service.unit, vip_price: @serve_admin_service.vip_price } },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Service.count', -1) do
      delete url_for(controller: 'serve/admin/services', action: 'destroy', id: @service.id), as: :turbo_stream
    end

    assert_response :success
  end

end
