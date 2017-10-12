class CreateJoinTableReservationsRooms < ActiveRecord::Migration[5.1]
  def change
    create_join_table :reservations, :rooms do |t|
      t.index [:reservation_id, :room_id]
      t.index [:room_id, :reservation_id]
    end
  end
end
