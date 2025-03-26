class SalahsController < ApplicationController
  before_action :require_authentication

  def new
    @salah = Salah.new
  end

  def create
    @salah = current_user.salahs.build(salah_params)
    if @salah.save
      flash[:notice] = "Salah details added successfully."
      redirect_to new_salah_path
    else
      flash.now[:alert] = "Failed to add Salah details."
      render :new
    end
  end

  def index
    @salahs = current_user.salahs.order(created_at: :desc)
  end

  private

  def salah_params
    params.require(:salah).permit(
      :salah_name, :where_prayed, :prayed_at_home_why, :prayed_timeliness,
      :reason, :prayed_congregation, :prayed_time, :transportation,
      :concentration, :sunnah_prayed, :tasbih_done, :tasbih_concentration
    )
  end

  def require_authentication
    redirect_to new_session_path, alert: "Please log in." unless current_user
  end
end
