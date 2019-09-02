require 'test_helper'

class Role::Admin::GovernTaxonsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @govern_taxon = create :govern_taxon
  end

  test 'index ok' do
    get admin_govern_taxons_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_govern_taxon_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('GovernTaxon.count') do
      post admin_govern_taxons_url, params: { govern_taxon: { code: 'admin/govern_taxon', name: 'test' } }
    end

    assert_redirected_to admin_govern_taxons_url
  end

  test 'destroy ok' do
    assert_difference('GovernTaxon.count', -1) do
      delete admin_govern_taxon_url(@govern_taxon)
    end

    assert_redirected_to admin_govern_taxons_url
  end
end
