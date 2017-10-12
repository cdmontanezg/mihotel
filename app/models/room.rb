class Room < ApplicationRecord
  belongs_to :hotel
  has_and_belongs_to_many :reservations
end
