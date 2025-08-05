require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_up_url
    assert_response :success
  end

  test "should post create and redirect" do
    post sign_up_url, params: { user: { email: "newuser@example.com", password: "password", password_confirmation: "password" } }
    assert_response :redirect
  end
end
