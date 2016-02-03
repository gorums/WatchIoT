##
# User model
#
class User < ActiveRecord::Base
  attr_accessor :passwd_confirmation, :passwd_new

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
  has_many :verify_clients
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

  validates :username, exclusion: { in: %w(home auth register verify login logout doc price download contact),
                                    message: '%{value} is reserved.' }

  before_create do
    generate_token(:auth_token)
    generate_api_key
    assign_plan
  end

  before_save :username_format

  ##
  # This method try to authenticate the client
  #
  def self.authenticate(email, passwd)
    return if passwd.empty?
    # find by email
    user_email = Email.where(email: email).where(principal: true).take

    user = user_email.user unless user_email.nil?
    # else find by username
    user = User.find_by_username(email) if user_email.nil?
    return if user.nil?

    user if user.status? && user.passwd == BCrypt::Engine.hash_secret(passwd, user.passwd_salt)
  end

  ##
  # Register with omniauth
  #
  def self.create_with_omniauth(auth)
    user = User.new
    user.provider = auth['provider']
    user.uid = auth['uid']
    user.first_name = first_name(auth['info']['name'])
    user.last_name = last_name(auth['info']['name'])
    user.username = auth['info']['nickname']
    user.passwd = generate_passwd

    email = Email.new
    email.email = auth['info']['email']
    save_user_and_mail user, email, true
    user
  end

  ##
  # Find member to add the team
  #
  def self.find_member(user_id, email_member)
    emails = Email.where(email: email_member).all

    return create_new_member(email_member) if emails.nil? || emails.empty?
    # if we find only one account
    if emails.length == 1
      # if is my email
      return if user_id == emails.first.user_id
      return User.find(emails.first.user_id)
    end

    # if we find more of one account, return the principal
    email = Email.where(email: email_member).where(principal: true).take
    unless email.nil?
      # if is my email
      return if user_id == email.user_id
      return User.find_by(id: email.user_id)
    end

  end

  ##
  # Create a new acount member
  #
  def self.create_new_member(email_member)
    email = Email.new(email: email_member)

    user_member = User.new
    user_member.username = email_member
    user_member.passwd = User.generate_passwd
    user_member.passwd_confirmation = user_member.passwd
    User.save_user_and_mail(user_member, email)

    token = VerifyClient.create_token(user_member.id, email_member, 'invited')
    Notifier.send_create_user_email(token, email_member).deliver_later
    user_member
  end

  ##
  # Get the principal email
  #
  def self.email(user_id)
    email = Email.find_by user_id: user_id, principal: true
    email
  end

  ##
  # Get the api key
  #
  def self.api_key(api_key_id)
    api_key = ApiKey.find_by id: api_key_id
    api_key.api_key
  end

  ##
  # Change the password
  #
  def self.change_passwd(user, params, validate = true)
    return if validate && user.passwd != BCrypt::Engine.hash_secret(params[:passwd], user.passwd_salt)
    return if params[:passwd_new] != params[:passwd_confirmation]

    user.update(passwd: BCrypt::Engine.hash_secret(params[:passwd_new], user.passwd_salt))
    true
  end

  ##
  # Change the user status to disable
  #
  def self.disable(user)
    user.status = false
    user.save!
  end

  ##
  # Save user and email routine
  #
  def self.save_user_and_mail(user, email, checked = false)
    user.passwd_salt = BCrypt::Engine.generate_salt
    user.passwd = BCrypt::Engine.hash_secret(user.passwd, user.passwd_salt)
    user.passwd_confirmation = user.passwd
    user.status = checked
    user.save!

    email.checked = checked
    email.principal = checked
    email.user_id = user.id
    email.save!
  end

  ##
  # Active the account after register and validate the email
  #
  def self.active_account(user, email, verifyClient)
    email.update(checked: true, principal: true)
    user.update(status: true)
    verifyClient.destroy
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
    username.gsub! /[^0-9a-z\- ]/i, '_'
    username.downcase!
  end

  ##
  # Generate a randow password
  #
  def self.generate_passwd
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
    password = ''
    10.times { password << chars[rand(chars.size)] }
    password
  end

  private

  ##
  # Split first name
  #
  def self.first_name(name)
    name.split(' ').first
  end

  ##
  # Split last name
  #
  def self.last_name(name)
    name.split(' ', 2).last
  end
end
