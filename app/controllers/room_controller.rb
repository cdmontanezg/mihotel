class RoomController < ApplicationController
  respond_to :json

  def index
      respond_to do |format|
        format.json { render json: Room.all }
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

  private
  def room_params
    params.require(:room)
  end

end