# test/system/salahs_test.rb
require "application_system_test_case"

class SalahsTest < ApplicationSystemTestCase
  setup do
    @user = User.create(email_address: "test@example.com", password: "password")
    @salah = Salah.create(user: @user, salah_name: "Isha", salah_prayed: true, created_at: Time.zone.today)
  end

  test "user can log in and see salah records" do
    visit new_session_path
    fill_in "Enter your email address", with: @user.email_address
    fill_in "Enter your password", with: "password"
    click_on "Sign in"
    assert_selector "h1", text: "Salah Records"
    assert_text "Isha"
  end

  test "user cannot add duplicate salah on the same day" do
    visit new_session_path
    fill_in "Enter your email address", with: @user.email_address
    fill_in "Enter your password", with: "password"
    click_on "Sign in"
    select "Isha", from: "Select Salah Name"
    check "Have you prayed this Salah?"
    click_on "Save Salah"
    assert_text "You've already logged this Salah today."
  end

  test "user can log out successfully" do
    visit new_session_path
    fill_in "Enter your email address", with: @user.email_address
    fill_in "Enter your password", with: "password"
    click_on "Sign in"
    assert_selector "h1", text: "Salah Records"
    click_on "Log out"
    assert_current_path new_session_path
    assert_text "You have been logged out."
  end
  
end
