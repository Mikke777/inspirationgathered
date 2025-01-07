class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :workshop

  has_many :messages, dependent: :destroy
end
