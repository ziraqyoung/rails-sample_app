class User < ApplicationRecord
  # callbacks
  before_save { email.downcase! }
  # validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false }
  validates :password, :password_confirmation, presence: true, length: { minimum: 6 }
  # bcrypt
  has_secure_password

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
