class SalahsController < ApplicationController
  before_action :authenticate_user!

  def index
    selected_date = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    @salah = Salah.new
    @salahs = current_user.salahs.where(created_at: selected_date.all_day).order(created_at: :desc)
  end

  def create
    existing_salah = current_user.salahs.find_by(
      salah_name: salah_params[:salah_name],
      created_at: Time.zone.today.all_day
    )
    if existing_salah
      redirect_to salahs_path, alert: "You've already logged this Salah today."
      return
    end

    @salah = current_user.salahs.build(salah_params)
    if @salah.save
      redirect_to salahs_path, notice: "Salah added successfully."
    else
      @salahs = current_user.salahs.where(created_at: Time.zone.today.all_day).order(created_at: :desc)
      render :index, alert: "Error adding Salah."
    end
  end

  private
  def salah_params
    params.require(:salah).permit(:salah_name, :salah_prayed)
  end
end
