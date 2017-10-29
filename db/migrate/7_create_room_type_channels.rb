class CreateRoomTypeChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :room_type_channels do |t|
      t.integer :beds
      t.string :room_channel_id
      t.belongs_to :channel, index: true

      t.timestamps
    end
  end
end