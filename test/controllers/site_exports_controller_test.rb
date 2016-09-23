require 'test_helper'

class SiteExportsControllerTest < ActionController::TestCase
  setup do
    login_user(:one)
    @search = searches(:one)
    @site_export = site_exports(:one)
  end

  test "create site export" do
    session[:current_search_id] = @search.id
    post :create

    assert_not_nil assigns(:site_export)
    assert_redirected_to assigns(:site_export)
  end

  test "should fail to create site export" do
    session[:current_search_id] = searches(:noresults).id
    post :create

    assert_not_nil assigns(:site_export)
    assert_redirected_to sites_path
  end


  test "show site export" do
    get :show, id: @site_export
    assert_response :success
  end

  test 'should retry site export' do
    get :retry, id: @site_export

    assert_equal 'queued', assigns(:site_export).status
    assert_redirected_to @site_export
  end
end
