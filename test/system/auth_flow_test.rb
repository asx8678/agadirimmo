require "application_system_test_case"

class AuthFlowTest < ApplicationSystemTestCase
  test "user can sign up, sign out, and sign in" do
    visit root_path

    # Sign up
    click_on I18n.t("nav.sign_up")
    fill_in I18n.t("auth.email"), with: "system@example.com"
    fill_in I18n.t("auth.password"), with: "password123"
    fill_in I18n.t("auth.password_confirmation"), with: "password123"
    click_on I18n.t("auth.sign_up")

    # Should now see sign out and new apartment link
    assert_selector :link_or_button, I18n.t("nav.sign_out")
    assert_selector :link, I18n.t("nav.new_apartment")

    # Sign out
    click_on I18n.t("nav.sign_out")
    assert_selector :link, I18n.t("nav.sign_in")

    # Sign in
    click_on I18n.t("nav.sign_in")
    fill_in I18n.t("auth.email"), with: "system@example.com"
    fill_in I18n.t("auth.password"), with: "password123"
    click_on I18n.t("auth.sign_in")
    assert_selector :link_or_button, I18n.t("nav.sign_out")
  end
end