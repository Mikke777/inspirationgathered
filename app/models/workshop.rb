class Workshop < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :bookings, dependent: :destroy
  has_many :booked_users, through: :bookings, source: :user
end
