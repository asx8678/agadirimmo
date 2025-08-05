class Apartment < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  enum :status, { draft: "draft", published: "published" }, prefix: true

  # Validations
  validates :title, presence: true, 
                   length: { minimum: 3, maximum: 200 }
                   
  validates :description, length: { maximum: 2000 }, allow_blank: true
  
  validates :latitude, presence: true,
                      numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
                      
  validates :longitude, presence: true,
                       numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
                       
  validates :price_cents, numericality: { greater_than: 0, less_than: 1_000_000_00 }, allow_nil: true
  
  validates :size_sqm, numericality: { greater_than: 0, less_than: 10_000 }, allow_nil: true
  
  validates :rooms, numericality: { greater_than: 0, less_than_or_equal_to: 50 }, allow_nil: true
  
  validates :address, length: { maximum: 500 }, allow_blank: true
  
  validates :city, presence: true, 
                  length: { minimum: 2, maximum: 100 }
                  
  validates :country, presence: true,
                     length: { minimum: 2, maximum: 100 }
                     
  validates :floor, numericality: { greater_than_or_equal_to: -10, less_than_or_equal_to: 200 }, allow_nil: true
  
  validates :year_built, numericality: { 
                          greater_than_or_equal_to: 1800, 
                          less_than_or_equal_to: Date.current.year + 5 
                        }, allow_nil: true
                        
  validates :amenities, length: { maximum: 1000 }, allow_blank: true

  # File upload validations
  validate :acceptable_photos

  # Sanitization
  before_save :sanitize_text_fields

  private

  def acceptable_photos
    return unless photos.attached?

    photos.each do |photo|
      unless photo.blob.content_type.in?(%w[image/jpeg image/png image/webp])
        errors.add(:photos, "must be JPEG, PNG, or WebP")
      end

      if photo.blob.byte_size > 10.megabytes
        errors.add(:photos, "must be less than 10MB")
      end
    end
  end

  def sanitize_text_fields
    self.title = title&.strip
    self.description = description&.strip
    self.address = address&.strip
    self.city = city&.strip
    self.country = country&.strip
    self.amenities = amenities&.strip
  end
end
