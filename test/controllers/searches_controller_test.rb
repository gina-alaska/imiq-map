require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @search = searches(:one)
  end

  test "should create search and redirect to search" do
    post :create, q: 'test', commit: 'search'

    assert_redirected_to search_path
  end

  test "should create search and redirect to export" do
    post :create, q: 'test', commit: 'export'

    assert_redirected_to new_export_path
  end

  test "should show search js" do
    session[:current_search_id] = @search.id
    xhr :get, :show, id: @search

    assert_response :success
  end
end
