# test/system/salahs_test.rb
require "application_system_test_case"

class SessionTest < ApplicationSystemTestCase
  setup do
    @user = User.create(email_address: "test@example.com", password: "password")
    @salah1 = Salah.create(user: @user, salah_name: "Isha", salah_prayed: true, created_at: Time.zone.today)
    @salah2 = Salah.create(user: @user, salah_name: "Maghrib", salah_prayed: false, created_at: Time.zone.today)
    @salah3 = Salah.create(user: @user, salah_name: "Fajr", salah_prayed: true, created_at: Time.zone.today)
  end

  test "successful login and salah display" do
    visit new_session_path
    fill_in "Enter your email address", with: @user.email_address
    fill_in "Enter your password", with: "password"
    click_on "Sign in"
    assert_selector "h1", text: "Salah Records"
    assert_text "Isha"
    assert_text "Maghrib"
    assert_text "Fajr"
  end

  test "login failure with wrong password" do
    visit new_session_path
    fill_in "Enter your email address", with: @user.email_address
    fill_in "Enter your password", with: "wrongpassword"
    click_on "Sign in"
    assert_current_path new_session_path
    assert_selector "#alert", text: "Try another email address or password."
  end

  test "multiple login attempts within rate limit" do
    3.times do
      visit new_session_path
      fill_in "Enter your email address", with: @user.email_address
      fill_in "Enter your password", with: "wrongpassword"
      click_on "Sign in"
    end
    assert_selector "#alert", text: "Try another email address or password."
  end
  
end
