require 'test_helper'

class DonwloadControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
