class SalahsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_salah, only: [ :destroy, :update ]

  def index
    selected_date = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    @salah = Salah.new
    @salahs = current_user.salahs.where(created_at: selected_date.all_day)
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
      @salahs = current_user.salahs.where(created_at: Time.zone.today.all_day)
      render :index, alert: "Error adding Salah."
    end
  end

  def destroy
    @salah.destroy
    redirect_to salahs_path, notice: "Salah deleted successfully."
  end

  def update
    if params[:toggle_status]
      @salah.update(salah_prayed: !@salah.salah_prayed)
      redirect_to salahs_path, notice: "Salah status updated successfully."
    else
      if @salah.update(salah_params)
        redirect_to salahs_path, notice: "Salah updated successfully."
      else
        redirect_to salahs_path, alert: "Error updating Salah."
      end
    end
  end

  private
  def salah_params
    params.require(:salah).permit(:salah_name, :salah_prayed)
  end

  def set_salah
    @salah = Salah.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to salahs_path, alert: "Salah not found."
  end
end
