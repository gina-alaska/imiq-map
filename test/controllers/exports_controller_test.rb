require 'test_helper'

class ExportsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @search = searches(:one)
    session[:current_search_id] = @search.id
  end

  test "cannot read other users export" do
    login_user(:two)
    get :show, id: exports(:one)

    assert_redirected_to root_path
  end

  test "should need to login to create export" do
    get :new

    assert_redirected_to login_path
  end

  test "should allow user to create export" do
    login_user(:one)

    get :new
    assert_response :success
  end

  test "should allow users to specify a specific site for export" do
    login_user(:one)

    get :new, siteid: 2056

    assert_response :success
  end
end
