class RoomTypeChannel < ApplicationRecord
  belongs_to :channel

  def self.get_beds_for_room_type_channel(room_type_channel, channel_id)
    beds = RoomTypeChannel.where('(room_channel_id = :room_channel_id AND channel_id = :channel_id)',
                                 room_channel_id: room_type_channel,
                                 channel_id: channel_id).first
    beds.beds
  end
end
