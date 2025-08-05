require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_in_url
    assert_response :success
  end

  test "should post create and redirect" do
    user = User.create!(email: "login@example.com", password: "password", password_confirmation: "password")
    post sign_in_url, params: { session: { email: user.email, password: "password" } }
    assert_response :redirect
  end

  test "should delete destroy and redirect" do
    user = User.create!(email: "logout@example.com", password: "password", password_confirmation: "password")
    # sign in first
    post sign_in_url, params: { session: { email: user.email, password: "password" } }
    delete sign_out_url
    assert_response :redirect
  end
end
