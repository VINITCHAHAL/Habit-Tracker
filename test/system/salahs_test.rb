# test/system/salahs_test.rb
require "application_system_test_case"

class SalahsTest < ApplicationSystemTestCase
  setup do
    @user = User.create(email_address: "test@example.com", password: "password")
    @salah = Salah.create(user: @user, salah_name: "Isha", salah_prayed: true, created_at: Time.zone.today)
  end

  def log_in(email, password)
    visit new_session_path
    fill_in "Enter your email address", with: email
    fill_in "Enter your password", with: password
    click_on "Sign in"
  end

  test "user can create a new salah record" do
    log_in(@user.email_address, "password")
    select "Maghrib", from: "Select Salah Name"
    check "Have you prayed this Salah?"
    click_on "Save Salah"
    assert_text "Salah added successfully."
    assert_text "Maghrib"
  end

  test "user cannot add duplicate salah on the same day" do
    log_in(@user.email_address, "password")
    select "Isha", from: "Select Salah Name"
    check "Have you prayed this Salah?"
    click_on "Save Salah"
    assert_text "You've already logged this Salah today."
  end
end
