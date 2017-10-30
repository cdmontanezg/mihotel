class RoomAvailability
  attr_accessor :beds, :date, :availability, :end_date, :room_channel_id

  def initialize(beds, date, availability)
    @beds = beds
    @date = date
    @availability = availability
  end

  def self.get_room_availability_for_changes(changes, hotel_id)
    result = []

    changes.each do |c|

      total_rooms = Room.where('beds = :beds', beds: c.beds).count
      start_date = c.start_date
      end_date = c.end_date

      while start_date < end_date
        found = result.select { |e| e.beds == c.beds and e.date == start_date }.first
        if found.nil?
          reservations = get_room_reservatios_for_date c.beds, start_date, hotel_id
          result << RoomAvailability.new(c.beds, start_date, total_rooms - reservations)
        end
        start_date += 1.day
      end

    end
    result
  end

  def self.get_room_reservatios_for_date(beds, date, hotel_id)
    reservations = Reservation.joins(:rooms).where('date_from <= :date AND date_to > :date AND rooms.hotel_id = :hotel_id AND rooms.beds = :beds',
                                    date: date, hotel_id: hotel_id, beds: beds). count

    reservations

  end

  def self.find_available_room(beds, start_date, end_date, hotel_id)

    occupied_rooms = Room.joins(:reservations).where('hotel_id = :hotel_id AND beds = :beds AND reservations.date_to > :start_date AND :end_date > reservations.date_from',
                                                   hotel_id: hotel_id, beds: beds, start_date: start_date, end_date: end_date)

    room = Room.where('hotel_id = :hotel_id AND beds = :beds', hotel_id: hotel_id, beds: beds).where.not(id: occupied_rooms).first

    room
  end

end