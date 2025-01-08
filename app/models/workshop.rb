class Workshop < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :bookings, dependent: :destroy
  has_many :booked_users, through: :bookings, source: :user
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?


  include PgSearch::Model


  pg_search_scope :global_search,
  against: [ :title, :description ],
  associated_against: {
    user: [ :name, :last_name ]
  },
  using: {
    tsearch: { prefix: true }
  }
end
