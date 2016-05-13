require 'test_helper'

class ExportsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "cannot read other users export" do
    login_user(:one)

    get :show, id: exports(:one)

    assert_redirected_to root_url
  end
end
