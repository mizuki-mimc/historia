require "test_helper"

class Admin::StoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_stories_index_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_stories_destroy_url
    assert_response :success
  end
end
