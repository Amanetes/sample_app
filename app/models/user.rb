# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email # включает 2 действия create & update
  before_create :create_activation_digest # включает 1 действие только create

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string. Метод для создания зашифрованного пароля (для фикстур)
  # Похожим способом реализован метод has_secure_password
  # переменная cost совпадает со значением ключа cost: поэтому можно опустить значение
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost:)
  end

  # Returns a random token. Необходимо для "запоминания сессии"
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end

  # Returns true if given token matches the digest.
  def authenticated?(attribute, token)
    # _digest всего 3 атрибута. У объекта на котором вызывается метод будет проверяться digest в зависимости от атрибута
    # Remember, Activation, Password
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now) # также как update_attribute скипает валидации
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  # Converts email to all lowercase.
  def downcase_email
    email.downcase!
    # self.email = email.downcase
  end

  # Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
