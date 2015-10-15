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

  validates_presence_of :username, :on => :create
  validates_presence_of :passwd, :on => :create
  validates_presence_of :passwd_confirmation, :on => :create
  validates_confirmation_of :passwd

  validates :passwd, length: { minimum: 8 }

  before_create do
    generate_token(:auth_token)
    generate_api_key
  end

  before_save :encrypt_password

  ##
  # This method try to authenticate the client
  #
  def self.authenticate(email, passwd)
    user = find_by_email(email)
    if user && user.passwd == BCrypt::Engine.hash_secret(passwd, user.passwd_salt)
      user
    else
      nil
    end
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

    api = ApiKey.new
    api.api_key = SecureRandom.uuid
    api.save
  end

end