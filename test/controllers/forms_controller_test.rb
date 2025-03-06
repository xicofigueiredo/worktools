require "test_helper"

class FormsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forms_index_url
    assert_response :success
  end

  test "should get show" do
    get forms_show_url
    assert_response :success
  end
end
