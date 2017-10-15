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
                      { name: 'Casa Blanca', city: 'Bogota', address: 'Calle 52 # 12 - 34', contact_name: 'Maria Ruiz' },
                      { name: 'La Republica', city: 'Bogota', address: 'Calle 52 # 12 - 35', contact_name: 'Jose Botero'}
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
                    { host_name: 'Juan Correa', host_email: 'jcorrea@gmail.com', date_from: '2017-10-01', date_to:'2017-10-12', status: 'Confirmed', channel: channels.first },
                    { host_name: 'Maria Perea', host_email: 'mperea@gmail.com', date_from: '2017-10-12', date_to:'2017-10-18', status: 'Arrived', channel: channels.first },
                    { host_name: 'Jorge Leon', host_email: 'jleon@gmail.com', date_from: '2017-10-25', date_to:'2017-11-2', status: 'New', channel: channels[1] },
                    { host_name: 'Luis Garcia', host_email: 'lgarcia@gmail.com', date_from: '2017-10-01', date_to:'2017-10-05', status: 'CheckedOut', channel: channels[1] },
                    ])

rooms[0].reservations << reservations[0]
rooms[1].reservations << reservations[1]
rooms[2].reservations << reservations[2]
rooms[4].reservations << reservations[3]
