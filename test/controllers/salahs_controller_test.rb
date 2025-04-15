require "test_helper"

class SalahsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email_address: "test@example.com", password: "password")
    @salah = Salah.create(user: @user, salah_name: "Fajr", salah_prayed: true, created_at: Time.zone.today)
  end

  def login_as(user)
    post session_path, params: { email_address: user.email_address, password: user.password }
  end

  def logout
    delete session_path
  end

  test "should get index" do
    login_as(@user)
    get salahs_url
    assert_response :success
    assert_template :index
  end

  test "should create salah when not logged today" do
    login_as(@user)
    assert_difference('Salah.count', 1) do
      post salahs_url, params: { salah: { salah_name: "Dhuhr", salah_prayed: true } }
    end
    assert_redirected_to salahs_path
    assert_equal "Salah added successfully.", flash[:notice]
  end

  test "should not create duplicate salah for today" do
    login_as(@user)
    post salahs_url, params: { salah: { salah_name: "Fajr", salah_prayed: true } }
    assert_no_difference('Salah.count') do
      post salahs_url, params: { salah: { salah_name: "Fajr", salah_prayed: true } }
    end
    assert_redirected_to salahs_path
    assert_equal "You've already logged this Salah today.", flash[:alert]
  end

  test "should logout user" do
    logout
    assert_nil session[:user_id], "Session was not cleared"
  end
end
