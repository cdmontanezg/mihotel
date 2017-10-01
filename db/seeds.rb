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
                    { number: '101', beds: 1, hotel: hotels.first },
                    { number: '102', beds: 1, hotel: hotels.first },
                    { number: '201', beds: 2, hotel: hotels.first },
                    { number: '202', beds: 2, hotel: hotels.first }
                    ])

# Reservation.create( [
#                    { host_name: 'Juan Correa', host_email: 'jcorrea@gmail.com', date_from: '2017-09-30', date_to:'2017-10-02', status: 1, channel: channels.first },
#                    { host_name: 'Juan Correa', host_email: 'jcorrea@gmail.com', date_from: '2017-09-30', date_to:'2017-10-02', status: 1, channel: channels.first  }
#                    ])