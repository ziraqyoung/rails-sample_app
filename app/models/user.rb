class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  # callbacks
  before_save :downcase_email
  before_create :create_activation_digest
  # validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false }
  # Using allow_nil, still requires new users to sign up with password
  # (required by bcrypt), though in this case update wont need password confirmation.
  validates :password, presence: true, length: { minimum: 6 }, allow_blank: true

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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # send activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Set password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(
      reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
    )
  end

  # send password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  # converts email to all lowercase
  def downcase_email
    email.downcase!
  end

  # creates and assign activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
