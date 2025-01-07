class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo
  has_many :workshops, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :booked_workshops, through: :bookings, source: :workshop
  has_many :messages, dependent: :destroy
end
