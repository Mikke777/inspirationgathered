class Workshop < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :bookings, dependent: :destroy
  has_many :booked_users, through: :bookings, source: :user
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  validate :photo_size
  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :address, presence: true
  validates :date, presence: true
  validates :photo, presence: true


  include PgSearch::Model


  pg_search_scope :global_search,
  against: [ :title, :description, :address ],
  associated_against: {
    user: [ :name, :last_name ]
  },
  using: {
    tsearch: { prefix: true }
  }

  private

  def photo_size
    if photo.attached? && photo.blob.byte_size > 1.megabyte
      errors.add(:photo, "size should be less than 1MB")
    end
  end
end
