require 'test_helper'

class Admin::VouchersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_vouchers_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_vouchers_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_vouchers_edit_url
    assert_response :success
  end

end
