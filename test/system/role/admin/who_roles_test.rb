require "application_system_test_case"

class WhoRolesTest < ApplicationSystemTestCase
  setup do
    @role_admin_who_role = role_admin_who_roles(:one)
  end

  test "visiting the index" do
    visit role_admin_who_roles_url
    assert_selector "h1", text: "Who Roles"
  end

  test "creating a Who role" do
    visit role_admin_who_roles_url
    click_on "New Who Role"

    fill_in "Created at", with: @role_admin_who_role.created_at
    fill_in "Who", with: @role_admin_who_role.who_id
    click_on "Create Who role"

    assert_text "Who role was successfully created"
    click_on "Back"
  end

  test "updating a Who role" do
    visit role_admin_who_roles_url
    click_on "Edit", match: :first

    fill_in "Created at", with: @role_admin_who_role.created_at
    fill_in "Who", with: @role_admin_who_role.who_id
    click_on "Update Who role"

    assert_text "Who role was successfully updated"
    click_on "Back"
  end

  test "destroying a Who role" do
    visit role_admin_who_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Who role was successfully destroyed"
  end
end
