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
  validates :places, numericality: { greater_than_or_equal_to: 1 }
  validate :places_not_decreased, on: :update

  def available_places
    (places || 10) - bookings.count
  end

  def can_book?
    available_places.positive?
  end

  include PgSearch::Model

  pg_search_scope :global_search,
                  against: %i[title description address],
                  associated_against: {
                    user: %i[name last_name]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  private

  def photo_size
    return unless photo.attached? && photo.blob.byte_size > 1.megabyte

    errors.add(:photo, "size should be less than 1MB")
  end

  def places_not_decreased
    return unless places_changed? && places_was > places

    errors.add(:places, "cannot be decreased once bookings have been made")
  end
end
