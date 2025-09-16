require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get orders_show_url
    assert_response :success
  end

  test "should get processing" do
    get orders_processing_url
    assert_response :success
  end
end
