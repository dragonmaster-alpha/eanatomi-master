require 'test_helper'

class EnquiriesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get enquiries_show_url
    assert_response :success
  end

end
