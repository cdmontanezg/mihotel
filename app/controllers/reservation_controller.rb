class ReservationController < ApplicationController
  respond_to :json
  protect_from_forgery unless: -> { request.format.json? }

  def events
    respond_to do |format|
      @reservations = []
      Reservation.where('(date_from >= :start_date OR date_from < :start_date) OR (date_to >= :end_date OR date_to < :end_date)',
                        start_date: params[:start],
                        end_date: params[:end]).find_each do |x|
        x.rooms.each do |r|
          @reservation = {
            id: x.id,
            text: x.host_name,
            start: x.date_from,
            end: x.date_to,
            resource: r.id,
            bubbleHtml: "<span class='" +  x.channel.name.gsub('.', '_') +  "'> </span>",
            status: x.status,
            paid: '100'
          }
          @reservations << @reservation
        end
      end

      format.json { render json: @reservations }
      format.html { render json: @reservations }
    end
  end

  def resize
    @reservation = Reservation.find_by(id: params[:id])
    @reservation.date_from = params[:newStart]
    @reservation.date_to = params[:newEnd]
    @reservation.save

    render json: [], status: :ok
  end

  def move
    @reservation = Reservation.find_by(id: params[:id])
    @reservation.date_from = params[:newStart]
    @reservation.date_to = params[:newEnd]
    @reservation.room_ids = [params[:newResource]]
    @reservation.save

    render json: { result: 'OK', message: 'OK' }, status: :ok
  end


  def delete
    @reservation = Reservation.find_by(id: params[:id])
    @reservation.destroy

    render json: [], status: :ok
  end

end