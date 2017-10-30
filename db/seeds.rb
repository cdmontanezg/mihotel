# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

channels = Channel.create([
                            { name: 'Booking.com', url: 'http://booking.com' },
                          { name: 'Expedia.com', url: 'http://expedia.com' }
                          ])

hotels = Hotel.create([
                      { name: 'Casa Blanca', city: 'Bogota', address: 'Calle 52 # 12 - 34', contact_name: 'Maria Ruiz' }
                      ])

rooms = Room.create([
                    { number: '101', beds: 1, hotel: hotels.first, status: 'Ready' },
                    { number: '102', beds: 1, hotel: hotels.first, status: 'Ready' },
                    { number: '201', beds: 2, hotel: hotels.first, status: 'Ready' },
                    { number: '202', beds: 2, hotel: hotels.first, status: 'Ready' },
                    { number: '301', beds: 4, hotel: hotels.first, status: 'Ready' },
                    { number: '302', beds: 4, hotel: hotels.first, status: 'Ready' }
                    ])

 reservations = Reservation.create( [
                    { host_name: 'Juan Correa', host_email: 'jcorrea@gmail.com', date_from: '2017-10-01', date_to:'2017-10-12', status: 'Confirmed', channel: channels.first, hotel: hotels[0] },
                    { host_name: 'Maria Perea', host_email: 'mperea@gmail.com', date_from: '2017-10-12', date_to:'2017-10-18', status: 'Arrived', channel: channels.first, hotel: hotels[0]  },
                    { host_name: 'Jorge Leon', host_email: 'jleon@gmail.com', date_from: '2017-10-25', date_to:'2017-11-2', status: 'New', channel: channels[1], hotel: hotels[0]  },
                    { host_name: 'Luis Garcia', host_email: 'lgarcia@gmail.com', date_from: '2017-10-01', date_to:'2017-10-05', status: 'CheckedOut', channel: channels[1], hotel: hotels[0]  },
                    ])

notificactions = Notification.create([
    {nombre_huesped: 'Juan Correa', descripcion: '1 habitación cama doble', fecha: '2017-10-01',canal: 1, hotel: hotels[0], reservation: reservations[0] },
    {nombre_huesped: 'Maria Perea', descripcion: '1 habitación cama sencilla', fecha: '2017-10-12', canal: 1, hotel: hotels[0], reservation: reservations[1]},
    {nombre_huesped: 'Jorge Leon', descripcion: '1 habitación cama sencilla', fecha: '2017-10-25', canal: 2, hotel: hotels[0], reservation: reservations[2]},
    {nombre_huesped: 'Luis Garcia', descripcion: '1 habitación cama doble', fecha: '2017-10-01', canal: 2, hotel: hotels[0], reservation: reservations[3]},
])

rooms[0].reservations << reservations[0]
rooms[1].reservations << reservations[1]
rooms[2].reservations << reservations[2]
rooms[4].reservations << reservations[3]

RoomTypeChannel.create ([
    { beds:1, room_channel_id: '201901242', channel: channels[1] },
    { beds:2, room_channel_id: '201547986', channel: channels[1] },
    { beds:4, room_channel_id: '201593685', channel: channels[1] },
])

HotelChannel.create ([
    { hotel_channel_id: '15240106', hotel: hotels.first, channel: channels[1] }
])