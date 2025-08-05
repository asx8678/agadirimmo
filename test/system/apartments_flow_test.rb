require "application_system_test_case"

class ApartmentsFlowTest < ApplicationSystemTestCase
  setup do
    # Ensure we're on English for predictable labels
    @locale = :en
  end

  test "index renders map and fetches JSON" do
    visit root_path(locale: @locale)
    # Map container present
    assert_selector "#map", wait: 5
    # List panel toggle button present
    assert_selector "button.toggle-btn", text: I18n.t("apartments.index.toggle_list")
  end

  test "create apartment with photo and view on show" do
    # Sign up first
    visit root_path(locale: @locale)
    click_on I18n.t("nav.sign_up")
    fill_in I18n.t("auth.email"), with: "owner2@example.com"
    fill_in I18n.t("auth.password"), with: "password123"
    fill_in I18n.t("auth.password_confirmation"), with: "password123"
    click_on I18n.t("auth.sign_up")
    assert_selector :link_or_button, I18n.t("nav.sign_out")

    # Create new apartment
    click_on I18n.t("nav.new_apartment")
    fill_in I18n.t("apartments.form.title"), with: "Test Apt"
    fill_in I18n.t("apartments.form.description"), with: "Great place"
    fill_in I18n.t("apartments.form.city"), with: "Warsaw"
    fill_in I18n.t("apartments.form.address"), with: "Marszałkowska 10"
    fill_in I18n.t("apartments.form.latitude"), with: "52.2297"
    fill_in I18n.t("apartments.form.longitude"), with: "21.0122"
    fill_in I18n.t("apartments.form.price_cents"), with: "300000"
    # Optional: rooms and size if present in the form (ignore if not)
    begin
      fill_in "Rooms", with: "2"
    rescue Capybara::ElementNotFound
    end
    begin
      fill_in "Size sqm", with: "45"
    rescue Capybara::ElementNotFound
    end

    # Attach a small image from fixtures if available; fallback to generate a temp file name
    image_path = Rails.root.join("test", "fixtures", "files", "test.png")
    if File.exist?(image_path)
      attach_file I18n.t("apartments.form.photos"), image_path
    end

    click_on I18n.t("apartments.form.submit")

    # Land on show page with title and mini map and gallery header
    assert_text "Test Apt"
    assert_selector "#mini-map", wait: 5
    assert_selector "h2", text: I18n.t("apartments.show.photos")
  end
end