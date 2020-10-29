require "application_system_test_case"

class NameSpacesTest < ApplicationSystemTestCase
  setup do
    @role_admin_name_space = role_admin_name_spaces(:one)
  end

  test "visiting the index" do
    visit role_admin_name_spaces_url
    assert_selector "h1", text: "Name Spaces"
  end

  test "creating a Name space" do
    visit role_admin_name_spaces_url
    click_on "New Name Space"

    fill_in "Identifier", with: @role_admin_name_space.identifier
    fill_in "Name", with: @role_admin_name_space.name
    fill_in "Verify member", with: @role_admin_name_space.verify_member
    fill_in "Verify organ", with: @role_admin_name_space.verify_organ
    fill_in "Verify user", with: @role_admin_name_space.verify_user
    click_on "Create Name space"

    assert_text "Name space was successfully created"
    click_on "Back"
  end

  test "updating a Name space" do
    visit role_admin_name_spaces_url
    click_on "Edit", match: :first

    fill_in "Identifier", with: @role_admin_name_space.identifier
    fill_in "Name", with: @role_admin_name_space.name
    fill_in "Verify member", with: @role_admin_name_space.verify_member
    fill_in "Verify organ", with: @role_admin_name_space.verify_organ
    fill_in "Verify user", with: @role_admin_name_space.verify_user
    click_on "Update Name space"

    assert_text "Name space was successfully updated"
    click_on "Back"
  end

  test "destroying a Name space" do
    visit role_admin_name_spaces_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Name space was successfully destroyed"
  end
end
