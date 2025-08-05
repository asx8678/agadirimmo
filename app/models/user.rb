class User < ApplicationRecord
  has_secure_password
  # Associations
  has_many :apartments, dependent: :destroy
  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
