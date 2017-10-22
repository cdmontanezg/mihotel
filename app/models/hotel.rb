class Hotel < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :notifications, dependent: destroy
end
