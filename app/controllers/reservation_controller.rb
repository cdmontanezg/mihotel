class ReservationController < ApplicationController
  respond_to :json
  def index
    respond_to do |format|
      format.json { render json: Reservation.all }
      format.html
    end
  end

  def create
    respond_with Reservation.create(reservation_params)
  end

  def destroy
    respond_with Reservation.destroy(params[:id])
  end

  def show
    respond_to do |format|
      format.json { render json: Reservation.find(params[:id]) }
      format.html
    end
  end

  private
  def reservation_params
    params.require(:reservation)
  end
end