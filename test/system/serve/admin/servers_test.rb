require "application_system_test_case"

class ServersTest < ApplicationSystemTestCase
  setup do
    @serve_admin_server = serve_admin_servers(:one)
  end

  test "visiting the index" do
    visit serve_admin_servers_url
    assert_selector "h1", text: "Servers"
  end

  test "should create server" do
    visit serve_admin_servers_url
    click_on "New server"

    fill_in "Member", with: @serve_admin_server.member_id
    fill_in "Name", with: @serve_admin_server.name
    click_on "Create Server"

    assert_text "Server was successfully created"
    click_on "Back"
  end

  test "should update Server" do
    visit serve_admin_server_url(@serve_admin_server)
    click_on "Edit this server", match: :first

    fill_in "Member", with: @serve_admin_server.member_id
    fill_in "Name", with: @serve_admin_server.name
    click_on "Update Server"

    assert_text "Server was successfully updated"
    click_on "Back"
  end

  test "should destroy Server" do
    visit serve_admin_server_url(@serve_admin_server)
    click_on "Destroy this server", match: :first

    assert_text "Server was successfully destroyed"
  end
end
