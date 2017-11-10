class ReservationController < ApplicationController
  respond_to :json
  protect_from_forgery unless: -> { request.format.json? }

  def events
    respond_to do |format|
      reservations = []
      Reservation.where('(date_from >= :start_date OR date_from < :start_date) OR (date_to >= :end_date OR date_to < :end_date)',
                        start_date: params[:start],
                        end_date: params[:end]).find_each do |x|
        x.rooms.each do |r|

          bubble_html = ''
          channel_id = ''

          unless x.channel.nil?
            bubble_html = "<span class='" + x.channel.name.gsub('.', '_') + "'> </span>" unless x.channel.nil?
            channel_id = x.channel.id unless x.channel.nil?
          end

          reservation = {
            id: x.id,
            text: x.host_name,
            start: x.date_from,
            end: x.date_to,
            resource: r.id,
            bubbleHtml: bubble_html,
            status: x.status,
            paid: '100',
            channelId: channel_id
          }
          reservations << reservation
        end
      end

      format.json { render json: reservations }
      format.html { render json: reservations }
    end
  end

  def resize
    reservation = Reservation.find_by(id: params[:id])
    reservation.date_from = params[:newStart]
    reservation.date_to = params[:newEnd]
    reservation.save

    render json: [], status: :ok
  end

  def move
    reservation = Reservation.find_by(id: params[:id])
    room = Room.find_by(id: params[:newResource])
    availability_change = []

    new_start_date = Date.parse(params[:newStart]).to_date
    new_end_date = Date.parse(params[:newEnd]).to_date

    if (reservation.date_from != new_start_date) ||
       (reservation.date_to != new_end_date) ||
       (reservation.rooms[0].beds != room.beds)

      availability_change << AvailabilityChange.new(reservation.rooms[0].beds, reservation.date_from, reservation.date_to)
      availability_change << AvailabilityChange.new(room.beds, new_start_date,new_end_date)
    end

    reservation.date_from = new_start_date
    reservation.date_to = new_end_date
    reservation.room_ids = [params[:newResource]]
    reservation.save

    sync_service = SyncService.new
    sync_service.delay.sync_channels_availability(availability_change)

    render json: { result: 'OK', message: 'OK' }, status: :ok
  end

  def delete
    reservation = Reservation.find_by(id: params[:id])
    availability_change = Reservation.try_delete_reservation reservation

    sync_service = SyncService.new
    sync_service.delay.sync_channels_availability([availability_change])

    render json: [], status: :ok
  end

  def create
    new_start_date = Date.parse(params[:start]).to_date
    new_end_date = Date.parse(params[:end]).to_date

    actual_reservation = Reservation.joins(:rooms).where(
      '((date_from BETWEEN ? AND ?)
      OR (date_to BETWEEN ? AND ?))
      AND rooms.id = ?',
      new_start_date.beginning_of_day,
      new_end_date.end_of_day,
      new_start_date.beginning_of_day,
      new_end_date.end_of_day,
      params[:resource]
    )

    if actual_reservation.empty?
      reservation = Reservation.new
      reservation.host_name = params[:name]
      reservation.host_email = params[:email]
      reservation.host_phone_number = params[:phone]
      reservation.date_from = new_start_date
      reservation.date_to = new_end_date
      reservation.status = params[:status]
      reservation.channel_id = params[:channel]
      reservation.created_at = Time.now
      reservation.updated_at = Time.now
      reservation.room_ids = [params[:resource]]

      room = Room.find_by(id: params[:resource])
      reservation.hotel_id = room.hotel_id

      reservation.save

      availability_change = AvailabilityChange.new(reservation.rooms[0].beds,
                                                   reservation.date_from,
                                                   reservation.date_to)
      sync_service = SyncService.new
      sync_service.delay.sync_channels_availability([availability_change])

      render json: { result: 'OK', message: 'OK' }, status: :ok
    else
      render json: { result: 'Error', message: 'Error' }, status: :ok
    end
  end

  def retrieve
    respond_to do |format|
      @reservation = Reservation.find_by(id: params[:id])

      format.json { render json: @reservation }
      format.html { render json: @reservation }
    end
  end

  def update
    reservation = Reservation.find_by(id: params[:id])
    availability_change = []

    new_start_date = Date.parse(params[:newStart]).to_date
    new_end_date = Date.parse(params[:newEnd]).to_date



    if (reservation.date_from != new_start_date) ||
       (reservation.date_to != new_end_date)
      availability_change << AvailabilityChange.new(reservation.rooms[0].beds, reservation.date_from, reservation.date_to)
      availability_change << AvailabilityChange.new(reservation.rooms[0].beds, new_start_date,new_end_date)
    end

    reservation.host_name = params[:newName]
    reservation.host_email = params[:newEmail]
    reservation.host_phone_number = params[:newPhone]
    reservation.date_from = new_start_date
    reservation.date_to = new_end_date
    reservation.status = params[:newStatus]
    reservation.updated_at = Time.now
    reservation.save

    sync_service = SyncService.new
    sync_service.delay.sync_channels_availability(availability_change)

    render json: { result: 'OK', message: 'OK' }, status: :ok
  end

  def index
    respond_to do |format|
      format.json { render json: Reservation.where(hotel_id: params[:hotel_id]).order(id: :desc) }
      format.html
    end
  end

  def show
    respond_to do |format|
      reservation = Reservation.find(params[:id]);
      format.json { render json: reservation }
      format.html
    end
  end

end
