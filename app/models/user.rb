class User < ApplicationRecord
  attr_accessor :remember_token
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
  validates :password,
            :password_confirmation,
            presence: true, length: { minimum: 6 }
  # bcrypt
  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # Return a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remember a user in db for user in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Return true if a given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end
end
