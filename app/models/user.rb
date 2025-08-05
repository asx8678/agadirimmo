class User < ApplicationRecord
  has_secure_password
  
  # Associations
  has_many :apartments, dependent: :destroy
  
  # Validations
  validates :email, presence: true, 
                   uniqueness: { case_sensitive: false }, 
                   format: { with: URI::MailTo::EMAIL_REGEXP },
                   length: { maximum: 255 }
                   
  validates :password, presence: true, 
                      length: { minimum: 8 }, 
                      format: { 
                        with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/, 
                        message: "must include at least one lowercase letter, one uppercase letter, and one digit" 
                      }, on: :create
                      
  validates :password, length: { minimum: 8 }, 
                      format: { 
                        with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/, 
                        message: "must include at least one lowercase letter, one uppercase letter, and one digit" 
                      }, on: :update, allow_blank: true

  # Normalize email before saving
  before_save :normalize_email

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
