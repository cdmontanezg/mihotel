class Reservation < ApplicationRecord
  belongs_to :channel
  has_and_belongs_to_many :rooms
  belongs_to :hotel
end
