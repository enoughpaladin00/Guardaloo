require "test_helper"

class ProfilePageControllerTest < ActionDispatch::IntegrationTest
  test "should get profile_index" do
    get profile_page_profile_index_url
    assert_response :success
  end
end
