# test/system/salahs_test.rb
require "application_system_test_case"

class SessionTest < ApplicationSystemTestCase
  setup do
    @user = User.create(email_address: "test@example.com", password: "password")
  end

  def log_in(email, password)
    visit new_session_path
    fill_in "Enter your email address", with: email
    fill_in "Enter your password", with: password
    click_on "Sign in"
  end

  test "user can log in and see salah records" do
    log_in(@user.email_address, "password")
    assert_selector "h1", text: "Salah Records"
    assert_text "Isha"
    assert_text "Maghrib"
    assert_text "Fajr"
  end

  test "login failure with wrong password" do
    log_in(@user.email_address, "wrongpassword")
    assert_current_path new_session_path
    assert_selector "#alert", text: "Try another email address or password."
  end

  test "user can log out successfully" do
    log_in(@user.email_address, "password")
    assert_selector "h1", text: "Salah Records"
    click_on "Log out"
    assert_current_path new_session_path
    assert_selector "#notice", text: "You have been logged out."
  end

  test "multiple login attempts with wrong password" do
    3.times do
      log_in(@user.email_address, "wrongpassword")
    end
    assert_selector "#alert", text: "Try another email address or password."
  end
end

