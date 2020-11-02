require "application_system_test_case"

class RoleRulesTest < ApplicationSystemTestCase
  setup do
    @role_panel_role_rule = role_panel_role_rules(:one)
  end

  test "visiting the index" do
    visit role_panel_role_rules_url
    assert_selector "h1", text: "Role Rules"
  end

  test "creating a Role rule" do
    visit role_panel_role_rules_url
    click_on "New Role Rule"

    fill_in "Action name", with: @role_panel_role_rule.action_name
    fill_in "Business identifier", with: @role_panel_role_rule.business_identifier
    fill_in "Controller identifier", with: @role_panel_role_rule.controller_identifier
    fill_in "Namespace identifier", with: @role_panel_role_rule.namespace_identifier
    fill_in "Params identifier", with: @role_panel_role_rule.params_identifier
    fill_in "Params name", with: @role_panel_role_rule.params_name
    click_on "Create Role rule"

    assert_text "Role rule was successfully created"
    click_on "Back"
  end

  test "updating a Role rule" do
    visit role_panel_role_rules_url
    click_on "Edit", match: :first

    fill_in "Action name", with: @role_panel_role_rule.action_name
    fill_in "Business identifier", with: @role_panel_role_rule.business_identifier
    fill_in "Controller identifier", with: @role_panel_role_rule.controller_identifier
    fill_in "Namespace identifier", with: @role_panel_role_rule.namespace_identifier
    fill_in "Params identifier", with: @role_panel_role_rule.params_identifier
    fill_in "Params name", with: @role_panel_role_rule.params_name
    click_on "Update Role rule"

    assert_text "Role rule was successfully updated"
    click_on "Back"
  end

  test "destroying a Role rule" do
    visit role_panel_role_rules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Role rule was successfully destroyed"
  end
end
