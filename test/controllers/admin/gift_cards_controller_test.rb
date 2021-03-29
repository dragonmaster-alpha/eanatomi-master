require 'test_helper'

class Admin::GiftCardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_gift_cards_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_gift_cards_show_url
    assert_response :success
  end

end
