require "test_helper"

class ApartmentTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "owner@example.com", password: "password", password_confirmation: "password")
    @base_attrs = {
      user: @user,
      title: "Sunny Studio",
      description: "Nice place near center",
      latitude: 52.23,
      longitude: 21.01,
      price_cents: 250_000,
      city: "Warsaw",
      address: "Marszałkowska 1",
      status: "published",
      rooms: 1,
      size_sqm: 25
    }
  end

  def build(attrs = {})
    Apartment.new(@base_attrs.merge(attrs))
  end

  test "valid apartment" do
    assert build.valid?
  end

  test "requires title, latitude, longitude presence (user association must exist for belongs_to)" do
    assert_not build(title: "").valid?
    assert_not build(latitude: nil).valid?
    assert_not build(longitude: nil).valid?

    # belongs_to implies must exist error when nil
    assert_not build(user: nil).valid?
  end

  test "latitude and longitude ranges" do
    assert_not build(latitude: 100).valid?
    assert_not build(latitude: -100).valid?
    assert_not build(longitude: 200).valid?
    assert_not build(longitude: -200).valid?
    assert build(latitude: 0, longitude: 0).valid?
  end

  test "price_cents is optional but if provided must be >= 0" do
    assert build(price_cents: nil).valid?
    assert_not build(price_cents: -1).valid?
    assert build(price_cents: 0).valid?
    assert build(price_cents: 1).valid?
  end

  test "size_sqm and rooms are optional but if provided must be >= 0" do
    assert build(size_sqm: nil, rooms: nil).valid?
    assert_not build(size_sqm: -5).valid?
    assert_not build(rooms: -1).valid?
    assert build(size_sqm: 0, rooms: 0).valid?
    assert build(size_sqm: 45, rooms: 2).valid?
  end

  test "status enum includes draft and published" do
    assert_includes Apartment.statuses.keys, "draft"
    assert_includes Apartment.statuses.keys, "published"
    assert build(status: "draft").valid?
  end
end
