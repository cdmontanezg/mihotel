class RoomController < ApplicationController
  respond_to :json
  protect_from_forgery unless: -> { request.format.json? }

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

  def available
    respond_to do |format|
      @rooms = Room.all.collect {|x| { id: x.id, name: x.number, capacity: x.beds, status: x.status } }
      format.json { render json: @rooms }
      format.html { render json: @rooms }
    end
  end

  def events
    respond_to do |format|

      @events = Reservation.all.collect {|x| { id: "x.id", text: x.host_name, start: x.date_from, end: x.date_to, resource: x.rooms[0].id, bubbleHtml:"Reservation details: <br\/>" + x.host_name, status:"New", paid:"0" } }
      format.json { render json: @events }
      format.html { render json: @events }
    end
  end

  private
  def room_params
    params.require(:room)
  end

end