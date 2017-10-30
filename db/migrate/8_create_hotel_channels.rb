class CreateHotelChannels< ActiveRecord::Migration[5.1]
  def change
    create_table :hotel_channels do |t|
      t.string :hotel_channel_id
      t.belongs_to :channel, index: true
      t.belongs_to :hotel, index: true

      t.timestamps
    end
  end
end