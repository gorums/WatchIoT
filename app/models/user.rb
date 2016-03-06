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
  # dont space admitted
  validates :username, length: { minimum: 1 }, format: { without: /\s+/,
                                 message: 'No empty spaces admitted for the username.' }
  validates_presence_of :username, on: :create
  validates_presence_of :passwd, on: :create
  validates_presence_of :passwd_confirmation, on: :create
  validates_confirmation_of :passwd

  validates :passwd, length: { minimum: 8 }

  validates :username, exclusion: { in: %w(home auth register verify login logout doc price download contact),
                                    message: '%{value} is reserved.' }

  before_validation :username_format

  before_create do
    generate_token(:auth_token)
    generate_api_key
    assign_plan
  end

  ##
  # Create a new account member
  #
  def self.create_new_account(email_member)
    password = User.generate_passwd
    user = User.new(username: email_member, passwd: password, passwd_confirmation: password)
    email = Email.new(email: email_member)
    save_user_and_email(user, email)

    token = VerifyClient.create_token(user.id, email_member, 'invited')
    Notifier.send_create_user_email(token, email_member).deliver_later
    user
  end

  ##
  # Disable the account
  #
  def self.delete_account(user, username)
    raise StandardError, 'The username is not valid' if user.username != username
    raise StandardError, 'You have to transfer'\
                         ' your spaces or delete their' if Space.exists?(user_id: user.id)
    user.update!(status: false)
  end

  ##
  # change the username
  #
  def self.change_username(user, new_username)
    user.update!(username: new_username)
  end

  ##
  # Register a new account
  #
  def self.register(user_params, email_s)
    user = User.new(user_params)
    email = Email.new(email: email_s)

    save_user_and_email user, email

    token = VerifyClient.create_token(user.id, email_s, 'register')
    Notifier.send_signup_email(user, email_s, token).deliver_later
  end

  ##
  # Change the password
  #
  def self.change_passwd(user, params)
    old_password = BCrypt::Engine.hash_secret(params[:passwd], user.passwd_salt)
    passwd_confirmation = params[:passwd_new] == params[:passwd_confirmation]
    same_old_passwd = user.passwd == old_password

    raise StandardError, 'The old password is not correctly' unless same_old_passwd
    raise StandardError, 'Password does not match the confirm password' unless passwd_confirmation

    user.update!(passwd: BCrypt::Engine.hash_secret(params[:passwd_new], user.passwd_salt))
  end

  ##
  # Login the account
  #
  def self.login(email, passwd)
    user = authenticate(email, passwd)
    raise StandardError, 'Account is not valid' if user.nil?
    user
  end

  ##
  # Register or login with omniauth
  #
  def self.omniauth
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
  end

  ##
  # Reset the password
  #
  def self.reset_passwd(user, params)
    passwd_confirmation = params[:passwd_new] == params[:passwd_confirmation]
    raise StandardError, 'Password does not match the confirm password' unless passwd_confirmation

    email = Email.find_principal_by_user(user.id).take || Email.find_by_user(user.id).take
    raise StandardError, 'You dont have a principal email, please contact us' if email.nil?

    # if the email is not principal it never has activated the account
    User.active_account(user, email) unless email.principal?

    Notifier.send_reset_passwd_email(user, email.email).deliver_later
    user.update!(passwd: BCrypt::Engine.hash_secret(params[:passwd_new], user.passwd_salt))
  end

  ##
  # Active the account after register and validate the email
  #
  def self.active_account(user, email)
    raise StandardError, 'The account can not be activate' if email.user.id != user.id
    email.update!(checked: true, principal: true)
    user.update!(status: true)

    Notifier.send_signup_verify_email(user, email.email).deliver_later
  end

  ##
  # A member was invite, finish register, enter username,
  # password and confirmation
  #
  def self.invite(user, user_params, email)
    user.username = user_params[:username] # set the username
    user.passwd = user_params[:passwd] # set the password
    user.passwd_confirmation = user_params[:passwd_confirmation]

    save_user_and_email(user, email, true)
  end

  ##
  # Send forgot notification
  #
  def self.send_forgot_notification(criteria)
    user = User.find_by_username criteria # find by username
    email = Email.find_principal_by_email(criteria).take # find by principal email

    # if it does not principal try to find for no principal
    email = Email.find_email_forgot(criteria) if user.nil? || email.nil?

    user = email.user if user.nil? && !email.nil?
    # find by user id first try with the principal or any
    email = Email.find_principal_by_user(user.id).take ||
            Email.find_by_user(user.id).take if email.nil? && !user.nil?

    return if user.nil? || email.nil?

    token = VerifyClient.create_token(user.id, email, 'reset')
    Notifier.send_forget_passwd_email(user, token, email).deliver_later
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
    self.plan_id = Plan.find_by_name('Free').id
  end

  ##
  # Set username always lowercase, self.name.gsub! /[^0-9a-z ]/i, '_'
  #
  def username_format
    self.username.gsub! /[^0-9a-z\- ]/i, '_'
    self.username.gsub! /\s+/, '_'
    self.username = self.username.byteslice 0 , 24
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
  # Save user and email routine
  #
  def self.save_user_and_email(user, email, checked = false)
    passwd_confirmation = user.passwd == user.passwd_confirmation
    passwd_is_short = user.passwd.length >= 8

    raise StandardError, 'Password does not match the confirm password' unless passwd_confirmation
    raise StandardError, 'Password has less than 8 characters' unless passwd_is_short
    raise StandardError, 'The email is principal in other account' if Email.find_principal_by_email(email.email).exists?

    save_user user, checked
    Email.save_email email, user.id, checked
    Notifier.send_signup_verify_email(user, email.email).deliver_later if checked
  end

  ##
  # Save user
  #
  def self.save_user(user, checked)
    user.passwd_salt = BCrypt::Engine.generate_salt
    user.passwd = BCrypt::Engine.hash_secret(user.passwd, user.passwd_salt)
    user.passwd_confirmation = user.passwd
    user.status = checked
    user.save!
  end

  ##
  # This method try to authenticate the client, other way return nil
  #
  def self.authenticate(email, passwd)
    return if passwd.empty?
    user_email = Email.find_principal_by_email(email).take

    user = user_email.user unless user_email.nil?
    user = User.find_by_username(email) if user_email.nil?
    return if user.nil?

    same_passwd = user.passwd == BCrypt::Engine.hash_secret(passwd, user.passwd_salt)
    user if user.status? && same_passwd
  end

  ##
  # Register with omniauth
  #
  def self.create_with_omniauth(auth)
    user = User.new(username: auth['info']['nickname'], provider: auth['provider'], uid: auth['uid'])
    user.first_name = first_name(auth['info']['name'])
    user.last_name = last_name(auth['info']['name'])
    user.passwd = generate_passwd
    user.passwd_confirmation = user.passwd

    email = Email.new(email: auth['info']['email'])
    save_user_and_email user, email, true
  end

  ##
  # Split first name
  #
  def self.first_name(name)
    name.split(' ').first[0..24]
  end

  ##
  # Split last name
  #
  def self.last_name(name)
    name.split(' ', 2).last[0..34]
  end
end
