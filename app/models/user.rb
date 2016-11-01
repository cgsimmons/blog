class User < ApplicationRecord
  attr_accessor :reset_token
  before_validation :downcase_email
  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i


  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: {case_sensitive: false},
                    format: VALID_EMAIL_REGEX


  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    # TODO: SEND AN EMAIL TO USER!
  end
  def generate_password_reset_link
    edit_password_reset_url(self.reset_token)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
                          BCrypt::Engine::MIN_COST :
                          BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def password_reset_expired?
    reset_sent_at < 3.days.ago
  end



  private

  def downcase_email
    email.downcase! if email.present?
  end

end
