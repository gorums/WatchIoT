##
# User model
#
class User < ActiveRecord::Base
  attr_accessor :passwd_confirmation

  has_many :emails
  has_many :spaces
  has_many :projects
  has_many :teams
  has_many :team_spaces
  has_many :team_projects
  has_many :securities
  has_many :logs
  has_many :stage_spaces
  has_many :stage_projects
  has_many :project_parameters
  has_many :project_requests
  has_many :project_webhooks
  has_many :project_evaluators

  has_one :api_key
  has_one :plan

  validates_uniqueness_of :username
  validates :username, format: { without: /\s+/,
                                 message: 'No empty spaces admitted for the username.' } # dont space admitted
  validates_presence_of :username, on: :create
  validates_presence_of :passwd, on: :create
  validates_presence_of :passwd_confirmation, on: :create
  validates_confirmation_of :passwd

  validates :passwd, length: { minimum: 8 }

  validates :username, exclusion: { in: %w(register login logout download home contact),
                                    message: '%{value} is reserved.' }

  before_create do
    generate_token(:auth_token)
    generate_api_key
    assign_plan
  end

  before_save :encrypt_password
  before_save :username_format

  ##
  # This method try to authenticate the client
  #
  def self.authenticate(email, passwd)
    # find by email
    user_email = Email.find_by_email(email)

    user = user_email.user if user_email && user_email.user
    # else find by username
    user = User.find_by_username(email) unless user

    if user && user.passwd == BCrypt::Engine.hash_secret(passwd, user.passwd_salt)
      return user
    end
  end

  ##
  # Get the principal email
  #
  def self.email(user_id)
    email = Email.find_by user_id: user_id, principal: true
    email.email
  end

  protected

  ##
  # This method generate a token for the client session
  #
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  ##
  # This method encrypt the password using a generate salt
  #
  def encrypt_password
    if passwd.present?
      self.passwd_salt = BCrypt::Engine.generate_salt
      self.passwd = BCrypt::Engine.hash_secret(passwd, passwd_salt)
    end
  end

  ##
  # This method generate an api key for the client
  #
  def generate_api_key
    begin
      api_key = SecureRandom.uuid
    end while ApiKey.exists?(:api_key => api_key)

    api = ApiKey.new
    api.api_key = api_key
    api.save

    self.api_key_id = api.id
  end

  ##
  # This method assign the free plan by default
  #
  def assign_plan
    self.plan_id = 1
  end

  ##
  # Set username always lowercase
  # self.name.gsub! /[^0-9a-z ]/i, '_'
  #
  def username_format
    username.gsub! /[^0-9a-z ]/i, '_'
    username.downcase!
  end
end
