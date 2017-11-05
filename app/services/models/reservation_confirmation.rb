class ReservationConfirmation
  attr_accessor :type, :channel_reservation_id, :confirm_number

  def initialize(type, channel_reservation_id, confirm_number)
    @type = type
    @channel_reservation_id = channel_reservation_id
    @confirm_number = confirm_number
  end
end