require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should xhr get search.js" do
    xhr :get, :search, { q: 'test' }
    assert_not_nil :search
    assert_equal assigns(:imiq_api_url), 'http://imiq-api.gina.alaska.edu/sites.geojson?geometry=point&limit=500&page=1&q=test'
    assert_response :success
  end
  
  test "should xhr get search.js as export" do
    xhr :get, :search, { q: 'test', commit: 'Export' }
    
    assert_template 'exports/new'
    assert_template 'exports/_export_modal.html'
    assert_template 'exports/_form'
    assert_response :success
  end
end
