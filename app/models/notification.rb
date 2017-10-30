class Notification < ApplicationRecord
  belongs_to :hotel
  belongs_to :reservation
end