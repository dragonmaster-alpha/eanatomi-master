require 'test_helper'

class Admin::PurchaseOrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_purchase_orders_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_purchase_orders_show_url
    assert_response :success
  end

end
