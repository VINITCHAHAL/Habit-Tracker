require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email_address: "test@example.com", password: "password123")
  end

  test "authenticates user with valid credentials" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "password123"
    }

    assert_redirected_to salahs_path
    follow_redirect!
    assert_match "Welcome back!", response.body
  end

  test "does not authenticate with invalid credentials" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "wrongpassword"
    }

    assert_redirected_to new_session_path
    follow_redirect!
    assert_match "Try another email address or password.", response.body
  end
end
