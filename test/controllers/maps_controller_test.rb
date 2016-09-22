require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should render index" do
    get :index

    assert_response :success
  end
end
