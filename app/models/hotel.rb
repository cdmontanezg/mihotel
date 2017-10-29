class Hotel < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :hotel_channels, dependent: :destroy
end
