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

  validates :name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :description, presence: true, length: { maximum: 100 }
  validates :photo, presence: true
  validate :photo_size

  private

  def photo_size
    if photo.attached? && photo.blob.byte_size > 200.kilobytes
      errors.add(:photo, "size should be less than 200KB")
    end
  end
end
