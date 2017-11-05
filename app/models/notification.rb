class Notification < ApplicationRecord
  belongs_to :hotel
  belongs_to :reservation, optional: true

  def self.add_notification(canal_id, reservation, reservation_type)

    description = ''

    if (reservation_type == 'Book')
      description = 'Nueva reserva, '
    elsif (reservation_type == 'Modify')
      description = 'Reserva modificada, '
    elsif (reservation_type == 'Cancel')
      description = 'Reserva cancelada, '
    end

    description += ' para ' +
        reservation.date_from.strftime('%m/%d/%Y') +
        ' hasta ' +
        reservation.date_to.strftime('%m/%d/%Y') +
        ' habitación ' +
        reservation.rooms[0].beds.to_s +
        ' camas'

    notification = Notification.new
    notification.nombre_huesped = reservation.host_name
    notification.fecha = Time.now
    notification.canal = canal_id
    notification.hotel_id = reservation.hotel_id
    notification.reservation_id = reservation.id
    notification.descripcion = description

    notification.save
  end


end