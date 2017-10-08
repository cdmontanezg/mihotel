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
      @rooms = [{ id: '1', name: 'Room 1', capacity: '2', status: 'Dirty' },
                { id: '2', name: 'Room 2', capacity: '2', status: 'Cleanup' },
                { id: '3', name: 'Room 3', capacity: '1', status: 'Ready' },
                { id: '4', name: 'Room 4', capacity: '4', status: 'Ready' }]

      format.json { render json: @rooms }
      format.html { render json: @rooms }
    end
  end

  def events
    respond_to do |format|
      @events =  [
          {id:"1",text:"Mrs. Jones",start:"2017-10-03T12:00:00",end:"2017-10-10T12:00:00",resource:"1",bubbleHtml:"Reservation details: <br\/>Mrs. Jones",status:"New",paid:"0"},
          {id:"2",text:"Mr. Lee",start:"2017-10-05T12:00:00",end:"2017-10-12T12:00:00",resource:"2",bubbleHtml:"Reservation details: <br\/>Mr. Lee",status:"Confirmed",paid:"0"},
          {id:"3",text:"Mr. Trump",start:"2017-10-02T12:00:00",end:"2017-10-07T12:00:00",resource:"3",bubbleHtml:"Reservation details: <br\/>Mr. Garc\u00eda",status:"Arrived",paid:"50"}
      ]
      format.json { render json: @events }
      format.html { render json: @events }
    end
  end

  private
  def room_params
    params.require(:room)
  end

end