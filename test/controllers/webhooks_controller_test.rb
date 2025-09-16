require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  test "should get dolly_delivery_status" do
    get webhooks_dolly_delivery_status_url
    assert_response :success
  end
end
