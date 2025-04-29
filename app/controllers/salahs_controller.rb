class SalahsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_salah, only: [:destroy, :update]
  before_action :set_date_range, only: :history

  def index
<<<<<<< HEAD
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
=======
    @salah = Salah.new
    @salahs = current_user.salahs.where(created_at: Time.zone.today.all_day)
    set_next_prayer
  end

  def history
    @salahs = current_user.salahs.for_date_range(@start_date, @end_date)
    @period_stats = Salah.calculate_period_statistics(@salahs, @start_date, @end_date)
    @prayer_stats = Salah.calculate_prayer_statistics(@salahs, @start_date, @end_date)
>>>>>>> 3a730d1 (Refactor SalahsController to improve code structure and enhance error handling)
  end

  def create
    @salah = current_user.salahs.build(salah_params)
    if @salah.save
      redirect_to salahs_path, notice: "Salah added successfully."
    else
      @salahs = current_user.salahs.where(created_at: Time.zone.today.all_day)
      flash.now[:alert] = @salah.errors.full_messages.join(", ")
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if params[:toggle_status]
      @salah.update(salah_prayed: !@salah.salah_prayed)
      redirect_to salahs_path, notice: "Salah status updated successfully."
    elsif @salah.update(salah_params)
      redirect_to salahs_path, notice: "Salah updated successfully."
    else
      redirect_to salahs_path, alert: @salah.errors.full_messages.join(", ")
    end
  end

  def destroy
    @salah.destroy
    redirect_to salahs_path, notice: "Salah deleted successfully."
  end

  private

  def set_salah
    @salah = current_user.salahs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to salahs_path, alert: "Salah not found."
  end

<<<<<<< HEAD
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
=======
  def set_date_range
    @view_type = params[:view] || 'monthly'
    @current_date = params[:date] ? Date.parse(params[:date]) : Time.zone.today
    @start_date, @end_date = case @view_type
    when 'weekly'
      [@current_date.beginning_of_week, @current_date.end_of_week]
    else
      [@current_date.beginning_of_month, @current_date.end_of_month]
    end
  end

  def set_next_prayer
    recorded_salahs = @salahs.pluck(:salah_name)
    @salah.salah_name = Salah::VALID_SALAH_NAMES.find { |name| !recorded_salahs.include?(name) } || Salah::VALID_SALAH_NAMES.first
  end

  def salah_params
    params.require(:salah).permit(:salah_name, :salah_prayed, :prayed_in_masjid)
>>>>>>> 3a730d1 (Refactor SalahsController to improve code structure and enhance error handling)
  end
end
