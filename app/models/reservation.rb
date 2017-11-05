class Reservation < ApplicationRecord
  belongs_to :channel, optional: true
  has_and_belongs_to_many :rooms
  belongs_to :hotel
  has_many :notifications, dependent: :nullify

  def self.try_delete_reservation(reservation)
    availability_change = AvailabilityChange.new reservation.rooms[0].beds,reservation.date_from,reservation.date_to
    reservation.rooms.delete_all
    reservation.notifications.delete_all
    reservation.delete
    availability_change
  end

end
