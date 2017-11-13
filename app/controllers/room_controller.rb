class RoomController < ApplicationController
  respond_to :json
  protect_from_forgery unless: -> { request.format.json? }

  def index
    respond_to do |format|
      format.json { render json: Room.where(hotel_id: params[:hotel_id]) }
      format.html
    end
  end

  def create
    respond_with Room.create(room_params)
  end

  def destroy
    respond_with Room.destroy(params[:id])
  end

  def show
    respond_to do |format|
      format.json { render json: Room.find(params[:id]) }
      format.html
    end
  end

  def available
    respond_to do |format|
      @rooms = Room.where(':capacity = 0 OR beds = :capacity',
                          capacity: params[:capacity]).collect { |x| { id: x.id, name: x.number, capacity: x.beds, status: x.status }
      }

      format.json { render json: @rooms }
      format.html { render json: @rooms }
    end
  end

  private
  def room_params
    params.require(:room)
  end

end