class Workshop < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :bookings, dependent: :destroy
  has_many :booked_users, through: :bookings, source: :user
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  validate :photo_size
  validates :title, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :date, presence: true


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
    if photo.attached? && photo.blob.byte_size > 10.megabytes
      errors.add(:photo, "size should be less than 10MB")
    end
  end
end
