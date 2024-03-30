require "test_helper"

class ExcelImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get excel_imports_new_url
    assert_response :success
  end

  test "should get create" do
    get excel_imports_create_url
    assert_response :success
  end
end
