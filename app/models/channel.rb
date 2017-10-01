class Channel < ApplicationRecord
  has_many :reservations, dependent: :destroy
end
