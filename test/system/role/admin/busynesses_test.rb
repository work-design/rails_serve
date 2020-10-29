require "application_system_test_case"

class BusynessesTest < ApplicationSystemTestCase
  setup do
    @role_admin_busyness = role_admin_busynesses(:one)
  end

  test "visiting the index" do
    visit role_admin_busynesses_url
    assert_selector "h1", text: "Busynesses"
  end

  test "creating a Busyness" do
    visit role_admin_busynesses_url
    click_on "New Busyness"

    fill_in "Identifier", with: @role_admin_busyness.identifier
    fill_in "Name", with: @role_admin_busyness.name
    click_on "Create Busyness"

    assert_text "Busyness was successfully created"
    click_on "Back"
  end

  test "updating a Busyness" do
    visit role_admin_busynesses_url
    click_on "Edit", match: :first

    fill_in "Identifier", with: @role_admin_busyness.identifier
    fill_in "Name", with: @role_admin_busyness.name
    click_on "Update Busyness"

    assert_text "Busyness was successfully updated"
    click_on "Back"
  end

  test "destroying a Busyness" do
    visit role_admin_busynesses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Busyness was successfully destroyed"
  end
end
