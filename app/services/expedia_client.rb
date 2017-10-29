class ExpediaClient
  require_relative '../services/models/reservation_channel'
  @@username =  APP_CONFIG['expedia_user']
  @@password =  APP_CONFIG['expedia_password']

  def get_new_reservations(hotel_id)
    @service_url = APP_CONFIG['expedia_base_uri'] + '/eqc/br'

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.BookingRetrievalRQ('xmlns' => 'http://www.expediaconnect.com/EQC/BR/2014/01') do
        xml.Authentication(username: @@username, password: @@password)
        xml.Hotel(id: hotel_id)
      end
    end

    @response = RestClient.post @service_url, builder.to_xml
    parse_reservation_response @response
  end

  def update_room_availability(hotel_id, room_type_id, start_date, end_date, available)
    @service_url = APP_CONFIG['expedia_base_uri'] + '/eqc/ar'

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.AvailRateUpdateRQ('xmlns' => 'http://www.expediaconnect.com/EQC/AR/2011/06') do
        xml.Authentication(username: @@username, password: @@password)
        xml.Hotel(id: hotel_id)
        xml.AvailRateUpdate() do
          xml.DateRange(from: start_date, to: end_date)
          xml.RoomType(id: room_type_id) do
            xml.Inventory(totalInventoryAvailable: available) {}
          end
        end
      end
    end

    @response = RestClient.post @service_url, builder.to_xml

  end

  def parse_reservation_response(response)
    doc = Nokogiri::Slop(response)
    doc.remove_namespaces!
    reservation_channels = []

    doc.xpath('//BookingRetrievalRS//Bookings//Booking').each do |r|
      reservation_channel = ReservationChannel.new
      reservation_channel.id = r[:id]
      reservation_channel.type = r[:type]
      reservation_channel.date = Date.parse(r[:createDateTime])
      reservation_channel.room_type_channel = r.RoomStay[:roomTypeID]
      reservation_channel.start_date = Date.parse(r.RoomStay.StayDate[:arrival])
      reservation_channel.end_date = Date.parse(r.RoomStay.StayDate[:departure])
      reservation_channel.host_name = r.PrimaryGuest.Name[:givenName].to_s + ' ' + r.PrimaryGuest.Name[:middleName].to_s + ' ' + r.PrimaryGuest.Name[:surname].to_s

      reservation_channels << reservation_channel
    end

    reservation_channels
  end
end
