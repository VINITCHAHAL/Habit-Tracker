class SalahsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_salah, only: [ :destroy, :update ]

  def index
    @view_mode = sanitize_view_mode
    @selected_date = sanitize_date_param
    @salah = Salah.new

    @salahs = case @view_mode
    when "weekly"
      current_user.salahs.where(created_at: @selected_date.beginning_of_week..@selected_date.end_of_week)
    when "monthly"
      current_user.salahs.where(created_at: @selected_date.beginning_of_month..@selected_date.end_of_month)
    else
      current_user.salahs.where(created_at: @selected_date.all_day)
    end

    if @selected_date == Time.zone.today
      salah_order = [ "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha" ]
      recorded_salahs = @salahs.pluck(:salah_name)
      @salah.salah_name = salah_order.find { |s| !recorded_salahs.include?(s) } || salah_order.first
    end
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
    params.require(:salah).permit(:salah_name, :salah_prayed, :prayed_in_masjid)
  end

  def set_salah
    @salah = Salah.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to salahs_path, alert: "Salah not found."
  end

  def sanitize_date_param
    return Time.zone.today unless params[:date].present?

    begin
      date = Date.parse(params[:date].to_s)
      if date.between?(1.year.ago.to_date, Time.zone.today)
        date
      else
        Time.zone.today
      end
    rescue ArgumentError, TypeError
      Time.zone.today
    end
  end

  def sanitize_view_mode
    return "daily" unless params[:view].present?
    [ "daily", "weekly", "monthly" ].include?(params[:view]) ? params[:view] : "daily"
  end
end
