class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.string :host_name
      t.string :host_email
      t.datetime :date_from
      t.datetime :date_to
      t.integer :status

      t.belongs_to :channel, index: true, foreign_key: true

      t.timestamps
    end
  end
end
