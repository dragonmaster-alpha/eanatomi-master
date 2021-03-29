require 'test_helper'

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_categories_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_categories_edit_url
    assert_response :success
  end

  test "should get _form" do
    get admin_categories__form_url
    assert_response :success
  end

end
