class Hotel < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :reservations, dependent: :destroy
end
