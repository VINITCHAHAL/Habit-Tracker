class SalahsController < ApplicationController
  before_action :authenticate_user!

  def index
    @salahs = current_user.salahs
    @salah = Salah.new
  end

  def create
    @salah = current_user.salahs.build(salah_params)
    if @salah.save
      redirect_to salahs_path, notice: "Salah added successfully."
    else
      render :index, alert: "Error adding Salah."
    end
  end

  private

  def salah_params
    params.require(:salah).permit(:salah_name, :salah_prayed)
  end
end
