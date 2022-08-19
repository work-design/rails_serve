require "application_system_test_case"

class ServicesTest < ApplicationSystemTestCase
  setup do
    @serve_admin_service = serve_admin_services(:one)
  end

  test "visiting the index" do
    visit serve_admin_services_url
    assert_selector "h1", text: "Services"
  end

  test "should create service" do
    visit serve_admin_services_url
    click_on "New service"

    fill_in "Name", with: @serve_admin_service.name
    fill_in "Price", with: @serve_admin_service.price
    fill_in "Unit", with: @serve_admin_service.unit
    fill_in "Vip price", with: @serve_admin_service.vip_price
    click_on "Create Service"

    assert_text "Service was successfully created"
    click_on "Back"
  end

  test "should update Service" do
    visit serve_admin_service_url(@serve_admin_service)
    click_on "Edit this service", match: :first

    fill_in "Name", with: @serve_admin_service.name
    fill_in "Price", with: @serve_admin_service.price
    fill_in "Unit", with: @serve_admin_service.unit
    fill_in "Vip price", with: @serve_admin_service.vip_price
    click_on "Update Service"

    assert_text "Service was successfully updated"
    click_on "Back"
  end

  test "should destroy Service" do
    visit serve_admin_service_url(@serve_admin_service)
    click_on "Destroy this service", match: :first

    assert_text "Service was successfully destroyed"
  end
end
