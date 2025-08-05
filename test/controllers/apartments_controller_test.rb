require "test_helper"

class ApartmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "tester@example.com", password: "password", password_confirmation: "password")
    @apartment = Apartment.create!(
      user: @user,
      title: "Test Apt",
      description: "Desc",
      latitude: 52.23,
      longitude: 21.01,
      price_cents: 123_000,
      city: "Warsaw",
      address: "Marszałkowska 1",
      status: "published",
      rooms: 1,
      size_sqm: 25
    )
  end

  test "should get show" do
    # Request the action and assert success, but avoid exercising the full template (which touches ActiveStorage)
    get apartment_url(@apartment, locale: :en), as: :html
    assert_response :success
  end

  test "should get new when authenticated" do
    post sign_in_url, params: { session: { email: @user.email, password: "password" } }
    get new_apartment_url(locale: :en)
    assert_response :success
  end

  test "should get edit when authenticated" do
    post sign_in_url, params: { session: { email: @user.email, password: "password" } }
    get edit_apartment_url(@apartment, locale: :en)
    assert_response :success
  end
end
