class BookingClient < ChannelClientBase

  require 'rest-client'

  @@username =  APP_CONFIG['booking_user']
  @@password =  APP_CONFIG['booking_password']

  def get_all_rooms(hotel_id)

    @service_url = APP_CONFIG['booking_base_uri'] + '/hotels/xml/rooms'

    @request = { username: @@username,
                 password: @@password,
                 hotel_id: hotel_id
    }

    @xml_request = @request.to_xml(root: :request, skip_types: true)
    @response = RestClient.get @service_url, params: { xml: @xml_request }
    @object_response = Nokogiri::Slop(@response)

    @rooms = []
    @object_response.rooms.room.each do |r|
      @room = Room.new
      @room.number = r['id']
      @rooms << @room
    end

    @rooms
  end

  def get_new_reservations(hotel_id)

    @service_url = APP_CONFIG['booking_base_uri'] + '/hotels/xml/reservationssummary'

    @request = { username: @@username,
                 password: @@password,
                 hotel_id: hotel_id
    }

    @xml_request = @request.to_xml(root: :request, skip_types: true)
    @response = RestClient.get @service_url, params: { xml: @xml_request }
    @object_response = Nokogiri::Slop(@response)

    @reservation = []



  end

  def update_rooms_status(hotel_id)

    @service_url = APP_CONFIG['booking_base_uri'] + '/hotels/ota/OTA_HotelInvNotif'

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.OTA_HotelInvNotifRQ('xmlns' => 'http://www.opentravel.org/OTA/2003/05',
                              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                              'xsi:schemaLocation' => 'http://www.opentravel.org/2014B/OTA_HotelInvNotifRQ.xsd',
                              'version' => '6.000',
                              'id' => 'OTA2014B',
                              'TransactionIdentifier' => '5',
                              'Target' => 'Test') {
        xml.SellableProducts(HotelCode: hotel_id) {
          xml.SellableProduct(InvNotifType: 'Overlay', InvStatusType: 'Deactivated', InvCode: '12345601'){
            xml.GuestRoom {
            }
          }
        }
      }
    end

    @response = RestClient.post @service_url, builder.to_xml

  end

end
