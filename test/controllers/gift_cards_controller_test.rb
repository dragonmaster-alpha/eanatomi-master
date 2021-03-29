require 'test_helper'

class GiftCardsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get gift_cards_new_url
    assert_response :success
  end

end
