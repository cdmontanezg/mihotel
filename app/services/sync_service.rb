class SyncService

  def sync_reservations_and_update_availability()
    hotel = Hotel.first
    channel = Channel.find_by(name: 'Expedia.com')
    client = ExpediaClient.new
    hotel_channel = hotel.hotel_channels.where(channel_id: channel.id).first

    availability_changes = sync_reservations channel, client, hotel, hotel_channel
    new_availability = RoomAvailability.get_room_availability_for_changes availability_changes, hotel.id
    update_new_availability channel, client, hotel_channel.hotel_channel_id, new_availability
  end

  def sync_reservations(channel, client, hotel, hotel_channel)
    availability_changes = []
    reservations = client.get_new_reservations(hotel_channel.hotel_channel_id)

    reservations.each do |r|
      if r.type == 'Book'
        change = try_create_reservation r, channel, hotel.id
        availability_changes << change unless change.nil?
      elsif r.type == 'Modify'
        change = try_modify_reservation r, channel, hotel.id
        availability_changes.concat change
      elsif r.type == 'Cancel'
        change = try_delete_reservation r, channel
        availability_changes << change unless change.nil?
      end
    end

    availability_changes
  end

  def try_create_reservation(reservation, channel, hotel_id)
    availability_change = nil
    current_reservation = Reservation.where('(channel_reservation_id = :channel_reservation_id AND channel_id = :channel_id)',
                                            channel_reservation_id: reservation.id,
                                            channel_id: channel.id).first

    beds = RoomTypeChannel.get_beds_for_room_type_channel reservation.room_type_channel, channel.id

    if current_reservation.nil?
      room = RoomAvailability.find_available_room beds, reservation.start_date, reservation.end_date, hotel_id
      current_reservation = Reservation.new
      current_reservation.channel_reservation_id = reservation.id
      current_reservation.reservation_date = reservation.date
      current_reservation.host_name = reservation.host_name
      current_reservation.date_from = reservation.start_date
      current_reservation.date_to = reservation.end_date
      current_reservation.channel = channel

      current_reservation.save
      room.reservations << current_reservation
      room.save

      availability_change = AvailabilityChange.new beds, reservation.start_date, reservation.end_date
    end

    availability_change
  end

  def try_modify_reservation(reservation, channel, hotel_id)
    availability_change = []
    current_reservation = Reservation.where('(channel_reservation_id = :channel_reservation_id AND channel_id = :channel_id)',
                                            channel_reservation_id: reservation.id,
                                            channel_id: channel.id).first

    unless current_reservation.nil?
      beds = RoomTypeChannel.get_beds_for_room_type_channel reservation.room_type_channel, channel.id
      if (current_reservation.date_from != reservation.start_date) ||
         (current_reservation.date_to != reservation.end_date) ||
         (current_reservation.rooms[0].beds != beds)

        availability_change << AvailabilityChange.new(beds, reservation.start_date, reservation.end_date)
        availability_change << AvailabilityChange.new(beds, current_reservation.date_from, current_reservation.date_to)

        current_reservation.rooms.delete_all
        current_reservation.save

        room = find_available_room beds, reservation.start_date, reservation.end_date, hotel_id

        current_reservation.reservation_date = reservation.date
        current_reservation.host_name = reservation.host_name
        current_reservation.date_from = reservation.start_date
        current_reservation.date_to = reservation.end_date
        current_reservation.channel = channel

        current_reservation.save
        room.reservations << current_reservation
        room.save
      end
    end

    availability_change
  end

  def try_delete_reservation(reservation, channel)
    availability_change = nil
    current_reservation = Reservation.where('channel_reservation_id = :channel_reservation_id AND channel_id = :channel_id',
                                            channel_reservation_id: reservation.id,
                                            channel_id: channel.id).first
    unless current_reservation.nil?
      availability_change = AvailabilityChange.new current_reservation.rooms[0].beds, current_reservation.date_from, current_reservation.date_to
      current_reservation.rooms.delete_all
      current_reservation.delete
    end

    availability_change
  end

  def update_new_availability(channel, client, hotel_channel_id, new_availability)

    create_ranges_from_availability(channel, new_availability).each do |r|
      client.update_room_availability(hotel_channel_id, r.room_channel_id, r.date, r.end_date, r.availability)
    end

  end

  def create_ranges_from_availability(channel, new_availability)
    ranges = []
    range = nil

    new_availability.sort_by(&:date).each do |c|
      if range.nil?
        range = RoomAvailability.new(c.beds, c.date, c.availability)
      elsif range.beds != c.beds || range.availability != c.availability || range.end_date + 1 != c.date
        ranges << range
        range = RoomAvailability.new(c.beds, c.date, c.availability)
      end

      range.end_date = c.date
    end

    ranges << range unless range.nil?
    set_channel_room_id channel, ranges
  end

  def set_channel_room_id(channel, new_availability)

    RoomTypeChannel.where('channel_id = :channel_id',
                          channel_id: channel.id).find_each do |x|

      new_availability.each do |c|
        if c.beds = x.beds
          c.room_channel_id = x.room_channel_id
        end
      end
    end

    new_availability
  end
end
