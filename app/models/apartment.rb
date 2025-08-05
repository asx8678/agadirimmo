class Apartment < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  enum :status, { draft: "draft", published: "published" }, prefix: true

  validates :title, :latitude, :longitude, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_nil: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :size_sqm, :rooms, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
