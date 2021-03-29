require 'test_helper'

class Admin::TranslationChangesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_translation_changes_index_url
    assert_response :success
  end

end
