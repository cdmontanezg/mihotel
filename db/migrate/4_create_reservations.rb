class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.string :host_name
      t.string :host_email
      t.string :host_phone_number
      t.datetime :date_from
      t.datetime :date_to
      t.string :channel_reservation_id
      t.string :status
      t.string :confirmation_number
      t.datetime :reservation_date

      t.belongs_to :hotel, index: true, foreign_key: true
      t.belongs_to :channel, index: true, foreign_key: true

      t.timestamps
    end
  end
end
